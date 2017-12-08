using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Amazon.Lambda.Core;
using Markdown.Common.Extensions;
using Markdown.Common.Settings.Interfaces;
using Microsoft.Extensions.Configuration;

namespace Markdown.Common.Settings
{
    public interface IMarkdownFunctionSettings : IMarkdownSettings, ICommonSettings
    {
    }

    public class MarkdownFunctionSettings : CommonSettings, IMarkdownFunctionSettings
    {
        public int OrganisationId { get; private set; }
        public int UserId { get; private set; }
        public int ModelId { get; private set; }
        public int ModelRunId { get; private set; }
        public int ScenarioId { get; private set; }
        public int RevisionId { get; private set; }
        public int PartitionId { get; private set; }
        public int PartitionCount { get; private set; }
        public bool Upload { get; private set; }
        public bool Calculate { get; private set; }

        public static string AspnetcoreEnvironment = "ASPNETCORE_ENVIRONMENT";

        private MarkdownFunctionSettings(IConfiguration configuration, ILambdaContext context = null) : base(configuration, context)
        {
        }

        public static IMarkdownFunctionSettings FromModelConfiguration(Dictionary<string, string> dictionary = null, ILambdaContext lambdaContext = null)
        {
            var configuration = GetConfiguration(MarkdownSwitchType.Model, dictionary);

            if (!Int32.TryParse(configuration["ModelId"], out int modelId))
                throw new ArgumentException("Model Id parameter could not be parsed", nameof(modelId));

            var result = new MarkdownFunctionSettings(configuration, lambdaContext)
            {
                ModelId = modelId
            };

            return result;
        }

        public static IMarkdownFunctionSettings FromPartitionConfiguration(Dictionary<string, string> dictionary = null, ILambdaContext lambdaContext = null)
        {
            var configuration = GetConfiguration(MarkdownSwitchType.Partition, dictionary);

            if (!Int32.TryParse(configuration["ModelId"], out int modelId))
                throw new ArgumentException("Model Id parameter could not be parsed", nameof(modelId));

            if (!Int32.TryParse(configuration["ModelRunId"], out int modelRunId))
                throw new ArgumentException("Model Run Id parameter could not be parsed", nameof(modelRunId));

            if (!Int32.TryParse(configuration["ScenarioId"], out int scenarioId))
                throw new ArgumentException("Scenario Id parameter could not be parsed", nameof(scenarioId));

			if (!Int32.TryParse(configuration["OrganisationId"], out int organisationId))
				throw new ArgumentException("Organisation Id parameter could not be parsed", nameof(organisationId));

			if (!Int32.TryParse(configuration["UserId"], out int userId))
				throw new ArgumentException("User Id parameter could not be parsed", nameof(userId));

            if (!Int32.TryParse(configuration["PartitionCount"], out int partitionCount))
                throw new ArgumentException("Partition Count parameter could not be parsed", nameof(partitionCount));

            BooleanHelper.TryParseInexact(configuration["Calculate"], out bool calculate);
            BooleanHelper.TryParseInexact(configuration["Upload"], out bool upload);

            var result = new MarkdownFunctionSettings(configuration, lambdaContext)
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionCount = partitionCount,
                Calculate = calculate,
                Upload = upload
            };

            return result;
        }

        public static IMarkdownFunctionSettings FromCalculateConfiguration(Dictionary<string, string> dictionary = null, ILambdaContext context = null)
        {
            var configuration = GetConfiguration(MarkdownSwitchType.Calculate, dictionary);
            
            if (!Int32.TryParse(configuration["ModelId"], out int modelId))
                throw new ArgumentException("Model Id parameter could not be parsed", nameof(modelId));

            if (!Int32.TryParse(configuration["ModelRunId"], out int modelRunId))
                throw new ArgumentException("Model Run Id parameter could not be parsed", nameof(modelRunId));

            if (!Int32.TryParse(configuration["ScenarioId"], out int scenarioId))
                throw new ArgumentException("Scenario Id parameter could not be parsed", nameof(scenarioId));

			if (!Int32.TryParse(configuration["OrganisationId"], out int organisationId))
				throw new ArgumentException("Organisation Id parameter could not be parsed", nameof(organisationId));

			if (!Int32.TryParse(configuration["UserId"], out int userId))
				throw new ArgumentException("User Id parameter could not be parsed", nameof(userId));
            
			if (!Int32.TryParse(configuration["PartitionId"], out int partitionId))
                throw new ArgumentException("Partition Id parameter could not be parsed", nameof(partitionId));

            if (!Int32.TryParse(configuration["PartitionCount"], out int partitionCount))
                throw new ArgumentException("Partition Count parameter could not be parsed", nameof(partitionCount));

            BooleanHelper.TryParseInexact(configuration["Upload"], out bool upload);

            var result = new MarkdownFunctionSettings(configuration, context)
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                OrganisationId = organisationId,
                UserId = userId,
                ScenarioId = scenarioId,
                PartitionId = partitionId,
                PartitionCount = partitionCount,
                Upload = upload
            };

            return result;
        }

        public static IMarkdownFunctionSettings FromWebApiConfiguration(int modelId, int modelRunId, int scenarioId, int organisationId,int userId, int partitionId, int partitionCount, Dictionary<string, string> dictionary = null, ILambdaContext context = null)
        {
            var configuration = GetConfiguration(MarkdownSwitchType.Calculate, dictionary);

            var result = new MarkdownFunctionSettings(configuration, context)
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionId = partitionId,
                PartitionCount = partitionCount,
                Upload = false
            };

            return result;
        }

        public static IMarkdownFunctionSettings FromUploadConfiguration(Dictionary<string, string> dictionary = null, ILambdaContext lambdaContext = null)
        {
            var configuration = GetConfiguration(MarkdownSwitchType.Upload, dictionary);

            if (!Int32.TryParse(configuration["ScenarioId"], out int scenarioId))
                throw new ArgumentException("Scenario Id parameter could not be parsed", nameof(scenarioId));
                       
            if (!Int32.TryParse(configuration["OrganisationId"], out int organisationId))
                throw new ArgumentException("Organisation Id parameter could not be parsed", nameof(organisationId));

			if (!Int32.TryParse(configuration["UserId"], out int userId))
				throw new ArgumentException("User Id parameter could not be parsed", nameof(userId));

            if (!Int32.TryParse(configuration["PartitionId"], out int partitionId))
                throw new ArgumentException("Partition Id parameter could not be parsed", nameof(partitionId));

            if (!Int32.TryParse(configuration["PartitionCount"], out int partitionCount))
                throw new ArgumentException("Partition Count parameter could not be parsed", nameof(partitionCount));

            var result = new MarkdownFunctionSettings(configuration, lambdaContext)
            {
                ScenarioId = scenarioId,
                PartitionId = partitionId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionCount = partitionCount
            };

            return result;
        }
        
        private static IConfigurationRoot GetConfiguration(MarkdownSwitchType switchType, Dictionary<string, string> dictionary)
        {
            Dictionary<string, string> switchMappings;
            switch (switchType)
            {
                case MarkdownSwitchType.Model:
                    switchMappings = new Dictionary<string, string>
                    {
                        {"--ConnectionString", "ConnectionString"},
                        {"--ModelId", "ModelId"}
                    };
                    break;
                case MarkdownSwitchType.Partition:
                    switchMappings = new Dictionary<string, string>
                    {
                        {"--ConnectionString", "ConnectionString"},
                        {"--ModelId", "ModelId"},
                        {"--ModelRunId", "ModelRunId"},
                        {"--ScenarioId", "ScenarioId"},
                        {"--OrganisationId", "OrganisationId"},
						 {"--UserId", "UserId"},
                        {"--PartitionCount", "PartitionCount"}
                    };
                    break;
                case MarkdownSwitchType.Calculate:
                    switchMappings = new Dictionary<string, string>
                    {
                        {"--ModelId", "ModelId"},
                        {"--ModelRunId", "ModelRunId"},
                        {"--ScenarioId", "ScenarioId"},
						 {"--OrganisationId", "OrganisationId"},
						 {"--UserId", "UserId"},
                        {"--PartitionId", "PartitionId"},
                        {"--PartitionCount", "PartitionCount"},
                        {"--Upload", "Upload"}
                    };
                    break;
                case MarkdownSwitchType.Upload:
                    switchMappings = new Dictionary<string, string>
                    {
                        {"--ConnectionString", "ConnectionString"},
                        {"--ScenarioId", "ScenarioId"},
						 {"--OrganisationId", "OrganisationId"},
						 {"--UserId", "UserId"},
                        {"--PartitionId", "PartitionId"},
                        {"--PartitionCount", "PartitionCount"}
                    };
                    break;
                case MarkdownSwitchType.WebApi:
                    switchMappings = new Dictionary<string, string>();
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(switchType), switchType, "Unknown MarkdownArgumentType");
            }

            string environment;
            try
            {
                environment = Environment
                    .GetEnvironmentVariable(AspnetcoreEnvironment)
                    .ToLower();
            }
            catch (Exception)
            {
                environment = string.Empty;
            }

            // appSettings.json
            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory()) // AWS Lambda fix
                .AddJsonFile("appSettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile("appSettings." + environment + ".json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables();

            // Commandline params
            var args = Environment.GetCommandLineArgs().AsEnumerable().Skip(1).ToArray();
            if (args.Length > 0)
                builder = builder.AddCommandLine(args, switchMappings);

            // Function params
            if (dictionary != null)
                builder = builder.AddInMemoryCollection(dictionary);

            return builder.Build();
        }
    }
}