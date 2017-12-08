using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Collections.Concurrent;
using Microsoft.Extensions.Configuration;

using Npgsql;
using Serilog;
using Newtonsoft.Json;

using Amazon.S3;
using Amazon.Lambda;
using Amazon.Lambda.Core;
using Amazon.Lambda.Model;

using SimpleInjector;
using SimpleInjector.Lifestyles;

using RetailAnalytics.Data;

using Markdown.Common.Extensions;
using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Markdown.Common.Statistics;

using Markdown.Data;
using Markdown.Service;
using Markdown.Service.Models;
using Markdown.Function.Common;
using Microsoft.Extensions.Caching.Memory;

namespace Markdown.Function.Main
{
    public class Calculate
    {
        public static IConfigurationRoot Configuration { get; set; }

        public static async Task Start(string program, string[] args, Dictionary<string, string> dictionary = null, ILambdaContext lambdaContext = null)
        {
            var settings = MarkdownFunctionSettings.FromCalculateConfiguration(dictionary, lambdaContext);
            var container = RegisterDependancies(settings, lambdaContext);
            var logger = container.GetInstance<ILogger>();

            using (AsyncScopedLifestyle.BeginScope(container))
            {
                try
                {
                    await Run(logger, settings, container);
                }
                catch (PostgresException e)
                {
                    logger.Error(e, "Postgres exception: {Detail}", e.Detail);
                    throw;
                }
                catch (Exception e)
                {
                    logger.Error(e, "Unhandled exception happened in the model");
                    throw;
                }
            }
        }
        
        public static async Task Run(ILogger logger, IMarkdownFunctionSettings settings, Container container)
        {
            logger.Information("Running. Settings: {@Settings}", settings);

            var canUpload = false;
            var statsInterval = TimeSpan.FromSeconds(10);
            var cancellationSource = new CancellationTokenSource();
            var cancellationToken = cancellationSource.Token;

            var calcService = container.GetInstance<IMarkdownService>();
            var functionService = container.GetInstance<IFunctionService>();
            var scenarioService = container.GetInstance<IScenarioService>();
            var scheduleService = container.GetInstance<IScheduleService>();

            try
            {
                // Inform AppDb we've started
                logger.Information("Calculate start (getting data and scenarios)");
                await functionService.CalculateStart(settings.ScenarioId, settings.PartitionCount, settings.PartitionId);

                // Todo: exclude products where markdown count > max markdown
                var model = await scenarioService.GetModelData(settings);
                var data = await scenarioService.GetScenarioData(settings, settings.PartitionId);

                var scenario = data.Item1;
                var products = data.Item2;
                var modelId = settings.ModelId;
                var revisionId = 0;

                var scheduleOptions = new SmScheduleOptions
                {
                    WeekMin = scenario.ScheduleWeekMin,
                    WeekMax = scenario.ScheduleWeekMax,
                    WeeksAllowed = scenario.ScheduleMask,
                    ExcludeConsecutiveWeeks = true
                };
                logger.Information("Getting schedules with {@Options}", scheduleOptions);
                var schedules = scheduleService.GetSchedules(scheduleOptions);
                logger.Information($"Got {schedules.Count} schedules");

                var decayHierarchies = model.DecayHierarchies;
                var elasticityHierarchies = model.ElasticityHierarchies;
                
                var recommendationResults = new ConcurrentBag<SmCalcProduct>();

                // Setup calculation
                var stats = new CalculationStatistics(logger, statsInterval);
                stats.AddTotalProductCount(products.Count);

                stats.Start();
                logger.Information("Product loop start");
                {
                    await functionService.CalculateUpdate(
                        settings.ScenarioId, 
                        settings.PartitionCount,
                        settings.PartitionId,
                        products.Count, 
                        stats.ProductCount, 
                        0, 
                        stats.PricePaths,
                        (int) stats.HierarchyErrorCount);

                    // Start
                    Parallel.ForEach(products,
                        x =>
                        {
                            stats.StartCalculation();
                            var product = calcService.Calculate(scenario, modelId, revisionId, schedules, decayHierarchies, elasticityHierarchies, x, null, cancellationToken);
                            stats.FinishCalculation();
                            stats.AddProducts(1L);
                            stats.AddPricePaths(product.ScheduleCrossProductCount);
                            stats.AddRecommendations(product.Recommendations.Count);
                            recommendationResults.Add(product);
                        });
                }
                logger.Information("Product loop finish");
                stats.Stop();

                // Save data
                logger.Information("Calculate save.");
                var s3Path = SmS3Path.ScenarioPartitionPath(SmS3PathName.Output, settings);
                await calcService.Save(recommendationResults.ToList(), s3Path);
                logger.Information("Calculate saved.");

                // Inform AppliationDb we've finished
                var productRate = stats.ProductCount / stats.ElapsedSeconds;
                var productCount = stats.ProductCount;
                var pricePathCount = stats.PricePaths;
                var hierarchyErrorCount = stats.HierarchyErrorCount;

                var finishResult = await functionService.CalculateFinish(settings.ScenarioId,settings.PartitionCount, settings.PartitionId,
                    products.Count, productCount, productRate, pricePathCount, (int)hierarchyErrorCount);

                // Detect finish state
                logger.Information("Finish state: {@Model}", finishResult);
                if (finishResult.SuccessCount == finishResult.FunctionInstanceTotal)
                {
                    canUpload = true;
                    logger.Information("This function is the last partition, where UploadQueue == Total");
                }

                logger.Information("Finished");
            }
            catch (Exception ex)
            {
                cancellationSource.Cancel();

                await functionService.CalculateError(settings.ScenarioId, settings.PartitionCount, settings.PartitionId, ex.ToString());
                throw;
            }

            if (canUpload && settings.Upload)
            {
                logger.Information("Launching upload function");
                var lambdaClient = container.GetInstance<IAmazonLambda>();
                for (var i = 1; i <= settings.PartitionCount; i++)
                {
                    await lambdaClient.InvokeAsync(new InvokeRequest
                    {
                        FunctionName = settings.FunctionName,
                        InvocationType = "Event",
                        Payload = JsonConvert.SerializeObject(new Dictionary<string, object>
                        {
                            {"Program", "upload"},
                            {"ScenarioId", settings.ScenarioId},
                            {"OrganisationId", settings.OrganisationId},
                            {"UserId", settings.UserId},
                            {"PartitionId", i},
                            {"PartitionCount", settings.PartitionCount}
                        })
                    }, cancellationToken);
                }
            }
        }
        
        public static Container RegisterDependancies(IMarkdownFunctionSettings settings, ILambdaContext lambdaContext)
        {
            IAmazonS3 s3Client;
            IAmazonLambda lambdaClient;
            if (lambdaContext != null)
            {
                s3Client = new AmazonS3Client();
                lambdaClient = new AmazonLambdaClient();
            }
            else
            {
                var awsOptions = settings.Configuration.GetAWSOptions();
                s3Client = awsOptions.CreateServiceClient<IAmazonS3>();
                lambdaClient = awsOptions.CreateServiceClient<IAmazonLambda>();
            }

            var logger = new LoggerConfiguration()
                .ReadFrom
                .Configuration(settings.Configuration)
                .Enrich.WithProperty("ModelId", settings.ModelId)
                .Enrich.WithProperty("ModelRunId", settings.ModelRunId)
                .Enrich.WithProperty("ScenarioId", settings.ScenarioId)
                .Enrich.WithProperty("OrganisationId", settings.OrganisationId)
                .Enrich.WithProperty("UserId", settings.UserId)
                .CreateLogger()
                .ForContext<Calculate>();

            // Singletons
            var container = new Container();
            container.Options.DefaultScopedLifestyle = new AsyncScopedLifestyle();

            container.RegisterSingleton(logger);
            container.RegisterSingleton(settings);
            container.RegisterSingleton(s3Client);
            container.RegisterSingleton(lambdaClient);
            container.RegisterSingleton<IS3Settings>(settings);
            container.RegisterSingleton<ISqlSettings>(settings);
            container.RegisterSingleton<ICloudWatchSettings>(settings);
            container.RegisterSingleton<IMemoryCache>(new MemoryCache(new MemoryCacheOptions()));

            container.Register<IMarkdownService, MarkdownService>(Lifestyle.Scoped);

            // Scoped
            container.Register<IDbConnectionProvider, DbConnectionProvider>(Lifestyle.Scoped);
            container.Register<IMarkdownSqlContext, MarkdownSqlContext>(Lifestyle.Scoped);
            container.Register<IOrganisationDataProvider, OrganisationDataProvider>(Lifestyle.Scoped);

            Service.Startup.RegisterDependancies(container);

            container.Verify();
            return container;
        }
    }
}

