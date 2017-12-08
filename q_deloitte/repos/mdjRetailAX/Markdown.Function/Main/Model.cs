using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

using Serilog;
using Amazon.S3;
using Amazon.Lambda.Core;
using SimpleInjector;
using SimpleInjector.Lifestyles;

using RetailAnalytics.Data;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Markdown.Data;
using Markdown.Service;
using Markdown.Function.Common;
using Npgsql;

namespace Markdown.Function.Main
{
    public class Model
    {
        public static IConfigurationRoot Configuration { get; set; }

        public static async Task Start(string program, string[] args, Dictionary<string, string> dictionary = null,
            ILambdaContext lambdaContext = null)
        {
            var settings = MarkdownFunctionSettings.FromModelConfiguration(dictionary, lambdaContext);
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
            var modelService = container.GetInstance<IModelService>();
            await modelService.Generate(settings);
        }

        public static Container RegisterDependancies(IMarkdownFunctionSettings settings, ILambdaContext lambdaContext)
        {
            IAmazonS3 s3Client;
            if (lambdaContext != null)
            {
                s3Client = new AmazonS3Client();
            }
            else
            {
                var awsOptions = settings.Configuration.GetAWSOptions();
                s3Client = awsOptions.CreateServiceClient<IAmazonS3>();
            }

            var logger = new LoggerConfiguration()
                .ReadFrom
                .Configuration(settings.Configuration)
                .Enrich.WithProperty("ModelId", settings.ModelId)
                .CreateLogger()
                .ForContext<Model>();


            var container = new Container();
            container.Options.DefaultScopedLifestyle = new AsyncScopedLifestyle();

            // Singletons
            container.RegisterSingleton(logger);
            container.RegisterSingleton(settings);
            container.RegisterSingleton(s3Client);
            container.RegisterSingleton<IS3Settings>(settings);
            container.RegisterSingleton<ISqlSettings>(settings);
            container.RegisterSingleton<ICloudWatchSettings>(settings);

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