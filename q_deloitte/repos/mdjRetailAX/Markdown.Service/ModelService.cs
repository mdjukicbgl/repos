using System.Linq;
using System.Diagnostics;
using System.Threading.Tasks;

using Markdown.Common.Extensions;
using Markdown.Common.Settings;
using Markdown.Data.Entity.App;
using Markdown.Data.Entity.Ephemeral;
using Markdown.Data.Repository.Ef;
using Markdown.Data.Repository.S3;
using Markdown.Service.Models;

using Serilog;

namespace Markdown.Service
{
    public interface IModelService
    {
        Task Generate(IMarkdownFunctionSettings settings);
    }

    public class ModelService : IModelService
    {
        private readonly ILogger _logger;
        private readonly IS3Repository _s3Repository;
        private readonly IEphemeralRepository _ephemeralRepository;

        public ModelService(ILogger logger, IS3Repository s3Repository, IEphemeralRepository ephemeralRepository)
        {
            _logger = logger.ForContext<ModelService>();
            _s3Repository = s3Repository;
            _ephemeralRepository = ephemeralRepository;
        }

        public async Task Generate(IMarkdownFunctionSettings settings)
        {
            _logger.Information("Generating model");

            await _ephemeralRepository.GenerateModel(settings.ModelId, async reader =>
            {
                var model = reader.Read<Model>().FirstOrDefault();
                var decayHierarchy = reader.Read<DecayHierarchy>().ToList();
                var elasticityHierarchy = reader.Read<ElasticityHierarchy>().ToList();

                var workingSet64 = Process.GetCurrentProcess().WorkingSet64;
                _logger.Debug("Generated model. Working Set is {Size} ({Bytes})", workingSet64.ToOrdinalString(), workingSet64);

                _logger.Information("Writing data to S3");
                var modelPath = SmS3Path.ModelPath(SmS3PathName.Model, settings.S3ModelBucketName, settings.S3ModelTemplate, settings.ModelId, model.ModelRunId);
                await _s3Repository.WriteRecord(modelPath, model);

                var elasticityPath = SmS3Path.ModelPath(SmS3PathName.ElasticityHierarchy, settings.S3ModelBucketName, settings.S3ModelTemplate, settings.ModelId, model.ModelRunId);
                await _s3Repository.WriteRecords(elasticityPath, elasticityHierarchy);

                var decayPath = SmS3Path.ModelPath(SmS3PathName.DecayHierarchy, settings.S3ModelBucketName, settings.S3ModelTemplate, settings.ModelId, model.ModelRunId);
                await _s3Repository.WriteRecords(decayPath, decayHierarchy);
            });

            _logger.Information("Model generation complete");
        }
    }
}
