using System;
using System.Linq;
using System.Collections.Generic;

using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Data.Entity;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmS3Path : IS3Path
    {
        public string BucketName { get; set; }
        public string Key { get; set; }
        
        public static SmS3Path ModelPath(SmS3PathName name, IMarkdownFunctionSettings settings)
        {
            return ModelPath(name, settings.S3ModelBucketName, settings.S3ModelTemplate, settings.ModelId, settings.ModelRunId);
        }

        public static SmS3Path ModelPath(SmS3PathName name, string bucketName, string bucketTemplate, int modelId, int modelRunId)
        {
            var replacement = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Key", name.ToString()},
                {"ModelId", modelId.ToString("0000")},
                {"ModelRunId", modelRunId.ToString("0000")},
                {"BucketName", bucketName}
            };

            return new SmS3Path
            {
                BucketName = bucketName,
                Key = replacement.Aggregate(bucketTemplate, (current, template) => current.Replace("%" + template.Key + "%", template.Value))
            };
        }

        public static SmS3Path ScenarioPath(SmS3PathName name, IMarkdownFunctionSettings settings)
        {
            return ScenarioPath(name, settings.S3ScenarioBucketName, settings.S3ScenarioTemplate,
                settings.ModelId, settings.ModelRunId, settings.ScenarioId);
        }

        public static SmS3Path ScenarioPath(SmS3PathName name, string bucketName, string bucketTemplate, int modelId, int modelRunId, int scenarioId)
        {
            var replacement = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Key", name.ToString()},
                {"ScenarioId", scenarioId.ToString("0000")},
                {"ModelId", modelId.ToString("0000")},
                {"ModelRunId", modelRunId.ToString("0000")},
                {"BucketName", bucketName}
            };

            return new SmS3Path
            {
                BucketName = bucketName,
                Key = replacement.Aggregate(bucketTemplate, (current, template) => current.Replace("%" + template.Key + "%", template.Value))
            };
        }
        public static SmS3Path ScenarioPartitionPath(SmS3PathName name, IMarkdownFunctionSettings settings)
        {
            return ScenarioPartitionPath(name, settings.S3ScenarioBucketName, settings.S3ScenarioPartitionTemplate,
                settings.ScenarioId, settings.PartitionId,
                settings.PartitionCount);
        }

        public static SmS3Path ScenarioPartitionPath(SmS3PathName name, IMarkdownFunctionSettings settings, int partitionId)
        {
            return ScenarioPartitionPath(name, settings.S3ScenarioBucketName, settings.S3ScenarioPartitionTemplate,
                settings.ScenarioId, partitionId,
                settings.PartitionCount);
        }
        
        public static SmS3Path ScenarioPartitionPath(SmS3PathName name, string bucketName, string bucketTemplate, int scenarioId, int partitionId, int partitionCount)
        {
            var replacement = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Key", name.ToString()},
                {"ScenarioId", scenarioId.ToString("0000")},
                {"BucketName", bucketName},
                {"PartitionId", partitionId.ToString("00")},
                {"PartitionCount", partitionCount.ToString("00")}
            };

            return new SmS3Path
            {
                BucketName = bucketName,
                Key = replacement.Aggregate(bucketTemplate, (current, template) => current.Replace("%" + template.Key + "%", template.Value))
            };
        }

        public static SmS3Path ScenarioPartitionPath(SmS3PathName name, string bucketName, string bucketTemplate, int scenarioId)
        {
            var replacement = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                {"Key", name.ToString()},
                {"ScenarioId", scenarioId.ToString("0000")},
                {"BucketName", bucketName},
            };

            return new SmS3Path
            {
                BucketName = bucketName,
                Key = replacement.Aggregate(bucketTemplate, (current, template) => current.Replace("%" + template.Key + "%", template.Value))
            };
        }
    }
}