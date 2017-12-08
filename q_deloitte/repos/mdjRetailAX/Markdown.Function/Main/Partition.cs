using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Amazon.Lambda;
using Amazon.Lambda.Core;
using Amazon.Lambda.Model;
using Amazon.S3;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Markdown.Data;
using Markdown.Function.Common;
using Markdown.Service;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Npgsql;
using RetailAnalytics.Data;
using Serilog;
using SimpleInjector;
using SimpleInjector.Lifestyles;

namespace Markdown.Function.Main
{
    public class Partition
    {
        public static IConfigurationRoot Configuration { get; set; }

        public static async Task Start(string program, string[] args, Dictionary<string, string> dictionary = null, ILambdaContext lambdaContext = null)
        {
            var settings = MarkdownFunctionSettings.FromPartitionConfiguration(dictionary, lambdaContext);
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
            logger.Information("Started. Settings: {@Settings}", settings);

            var functionService = container.GetInstance<IFunctionService>();
            await functionService.PartitionStart(settings.ScenarioId);

            var partitionService = container.GetInstance<IPartitionService>();
            var scenarioWebService = container.GetInstance<IScenarioWebService>();

            var summary = await scenarioWebService.Get(0, settings.ScenarioId);

            try
            {
                await partitionService.Split(settings, summary.Scenario.Week ?? 10000, summary.Scenario.ScheduleWeekMin, summary.Scenario.ScheduleWeekMax , summary.Scenario.MarkdownCountStartWeek, summary.Scenario.AllowPromoAsMarkdown, summary.Scenario.MinimumPromoPercentage);
            }
            catch (Exception e)
            {
                await functionService.PartitionError(settings.ScenarioId, "Error partitioning: " + e);
                throw;
            }

            await functionService.PartitionFinish(settings.ScenarioId);

            if (settings.Calculate)
            {
                logger.Information("Launching calculate functions");
                var lambdaClient = container.GetInstance<IAmazonLambda>();
                for (var i = 1; i <= settings.PartitionCount; i++)
                {
                    await lambdaClient.InvokeAsync(new InvokeRequest
                    {
                        FunctionName = settings.FunctionName,
                        InvocationType = "Event",
                        Payload = JsonConvert.SerializeObject(new Dictionary<string, object>
                        {
                            {"Program", "calc"},
                            {"ModelId", settings.ModelId},
                            {"ModelRunId", settings.ModelRunId},
                            {"ScenarioId", settings.ScenarioId},
                            {"OrganisationId", settings.OrganisationId},
                            {"UserId", settings.UserId},
                            {"PartitionId", i},
                            {"PartitionCount", settings.PartitionCount},
                            {"Upload", settings.Upload}
                        })
                    });
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
                .CreateLogger()
                .ForContext<Partition>();

            var container = new Container();
            container.Options.DefaultScopedLifestyle = new AsyncScopedLifestyle();

            // Singletons
            container.RegisterSingleton(logger);
            container.RegisterSingleton(settings);
            container.RegisterSingleton(s3Client);
            container.RegisterSingleton(lambdaClient);
            container.RegisterSingleton<IS3Settings>(settings);
            container.RegisterSingleton<ISqlSettings>(settings);
            container.RegisterSingleton<ICloudWatchSettings>(settings);

            // Scoped
            container.Register<IDbConnectionProvider, DbConnectionProvider>(Lifestyle.Scoped);
            container.Register<IOrganisationDataProvider, OrganisationDataProvider>(Lifestyle.Scoped);
            container.Register<IMarkdownSqlContext, MarkdownSqlContext>(Lifestyle.Scoped);

            Service.Startup.RegisterDependancies(container);

            container.Verify();
            return container;
        }
    }
}