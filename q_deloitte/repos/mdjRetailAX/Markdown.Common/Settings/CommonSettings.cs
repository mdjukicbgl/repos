using System;
using Amazon.Lambda.Core;
using Markdown.Common.Settings.Interfaces;
using Microsoft.Extensions.Configuration;
using Npgsql;

namespace Markdown.Common.Settings
{
    public interface ICommonSettings : ISqlSettings, IS3Settings, ICloudWatchSettings {
        IConfiguration Configuration { get; set; }
    }

    public class CommonSettings : ICommonSettings
    {
        public string AppConnectionString { get; }

        public string EphemeralConnectionString { get; }

        public string S3ModelBucketName { get; }
        public string S3ModelTemplate { get; }
        public string S3ScenarioTemplate { get; }

        public string S3ScenarioBucketName { get; }
        public string S3ScenarioPartitionTemplate { get; }
        
        public string LogGroupName { get; }
        public string LogStreamName { get; }
        public string FunctionName { get; set; } = "None";
        public string FunctionVersion { get; set; } = "None";
        
        public IConfiguration Configuration { get; set; }

        public CommonSettings(IConfiguration configuration, ILambdaContext context = null)
        {
            var appConnectionString = configuration["AppConnection"] ?? configuration.GetConnectionString("AppConnection");
            if (string.IsNullOrWhiteSpace(appConnectionString))
                throw new Exception("Missing AppConnection in configuration");

            var ephemeralConnectionString = configuration["EphemeralConnection"] ?? configuration.GetConnectionString("EphemeralConnection");
            if (string.IsNullOrWhiteSpace(appConnectionString))
                throw new Exception("Missing EphemeralConnection in configuration");
            
            var settings = configuration.GetSection("Settings");

            var modelBucketName = configuration["S3ModelBucketName"] ?? settings["S3ModelBucketName"];
            if (string.IsNullOrWhiteSpace(modelBucketName))
                throw new ArgumentException("S3 Model Bucket Key parameter could not be parsed",
                    nameof(modelBucketName));

            var modelTemplate = configuration["S3ModelTemplate"] ?? settings["S3ModelTemplate"];
            if (string.IsNullOrWhiteSpace(modelTemplate))
                throw new ArgumentException("S3 Model Template parameter could not be parsed", 
                    nameof(modelTemplate));

            var scenarioTemplate = configuration["S3ScenarioTemplate"] ?? settings["S3ScenarioTemplate"];
            if (string.IsNullOrWhiteSpace(scenarioTemplate))
                throw new ArgumentException("S3 Scenario Template parameter could not be parsed",
                    nameof(scenarioTemplate));

            var scenarioBucketName = configuration["S3ScenarioBucketName"] ?? settings["S3ScenarioBucketName"];
            if (string.IsNullOrWhiteSpace(scenarioBucketName))
                throw new ArgumentException("S3 Scenario Bucket Key parameter could not be parsed",
                    nameof(scenarioBucketName));

            var scenarioPartitionTemplate = configuration["S3ScenarioPartitionTemplate"] ?? settings["S3ScenarioPartitionTemplate"];
            if (string.IsNullOrWhiteSpace(scenarioPartitionTemplate))
                throw new ArgumentException("S3 Scenario Partition Template parameter could not be parsed",
                    nameof(scenarioPartitionTemplate));

            AppConnectionString = new NpgsqlConnectionStringBuilder(appConnectionString)
            {
                KeepAlive = 15,
                ApplicationName = "Markdown.App"
            }.ToString();

            EphemeralConnectionString = new NpgsqlConnectionStringBuilder(ephemeralConnectionString)
            {
                KeepAlive = 15,
                ApplicationName = "Markdown.Ephemeral"
            }.ToString();

            S3ModelBucketName = modelBucketName;
            S3ModelTemplate = modelTemplate;

            S3ScenarioTemplate = scenarioTemplate;
            S3ScenarioBucketName = scenarioBucketName;
            S3ScenarioPartitionTemplate = scenarioPartitionTemplate;

            if (context != null)
            {
                LogGroupName = context.LogGroupName;
                LogStreamName = context.LogStreamName;
                FunctionName = context.FunctionName;
                FunctionVersion = context.FunctionVersion;
            }

            Configuration = configuration;
        }
    }
}