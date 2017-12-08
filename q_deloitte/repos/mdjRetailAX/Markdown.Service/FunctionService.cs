using System.Threading.Tasks;
using Markdown.Common.Enums;
using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Markdown.Data.Entity.Json;
using Markdown.Data.Repository.Ef;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IFunctionService
    {
        Task<SmFunctionGroupSummary> PartitionStart(int scenarioId);
        Task<SmFunctionGroupSummary> PartitionUpdate(int scenarioId);
        Task<SmFunctionGroupSummary> PartitionFinish(int scenarioId);
        Task<SmFunctionGroupSummary> PartitionError(int scenarioId, string errorMessage);
        Task<SmFunctionGroupSummary> CalculateStart(int scenarioId, int instanceTotal, int instanceNumber);
        Task<SmFunctionGroupSummary> CalculateUpdate(int scenarioId, int instanceTotal, int instanceNumber, long productTotal,
            long productCount, double productRate, long recommendationCount, int hierarchyErrorCount);
        Task<SmFunctionGroupSummary> CalculateFinish(int scenarioId, int instanceTotal, int instanceNumber, long productTotal,
            long productCount, double productRate, long recommendationCount, int hierarchyErrorCount);
        Task<SmFunctionGroupSummary> CalculateError(int scenarioId, int instanceTotal, int instanceNumber, string errorMessage);
        Task<SmFunctionGroupSummary> UploadStart(int scenarioId);
        Task<SmFunctionGroupSummary> UploadUpdate(int scenarioId);
        Task<SmFunctionGroupSummary> UploadFinish(int scenarioId);
        Task<SmFunctionGroupSummary> UploadError(int scenarioId, string errorMessage);
    }

    public class FunctionService : IFunctionService
    {
        private readonly ICloudWatchSettings _cloudWatchSettings;
        private readonly IFunctionRepository _functionRepository;

        public FunctionService(ICloudWatchSettings cloudWatchSettings, IFunctionRepository functionRepository)
        {
            _cloudWatchSettings = cloudWatchSettings;
            _functionRepository = functionRepository;
        }

        //
        // Partition
        //
        public async Task<SmFunctionGroupSummary> PartitionStart(int scenarioId)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Partition,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.PartitionStarting, 1,
                new FunctionInstancePartitionJson(_cloudWatchSettings));

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> PartitionUpdate(int scenarioId)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Partition,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.PartitionRunning, 1,
                new FunctionInstancePartitionJson(_cloudWatchSettings));

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> PartitionFinish(int scenarioId)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Partition,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.PartitionFinished, 1,
                new FunctionInstancePartitionJson(_cloudWatchSettings));

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> PartitionError(int scenarioId, string errorMessage)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Partition,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.PartitionError, 1,
                new FunctionInstancePartitionJson(_cloudWatchSettings)
                {
                    ErrorMessage = errorMessage
                });

            return SmFunctionGroupSummary.Build(result);
        }

        //
        // Calculate
        //
        public async Task<SmFunctionGroupSummary> CalculateStart(int scenarioId, int instanceTotal, int instanceNumber)
        {
            var model = new FunctionInstanceCalculateJson(_cloudWatchSettings);

            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Calculate,
                _cloudWatchSettings.FunctionVersion, instanceTotal, FunctionInstanceType.CalculateStarting, instanceNumber,
                model);

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> CalculateUpdate(int scenarioId, int instanceTotal, int instanceNumber, long productTotal, long productCount, double productRate, long recommendationCount, int hierarchyErrorCount)
        {
            var model = new FunctionInstanceCalculateJson(_cloudWatchSettings)
            {
                ProductTotal = productTotal,
                ProductCount = productCount,
                ProductRate = productRate,
                RecommendationCount = recommendationCount,
                HierarchyErrorCount = hierarchyErrorCount
            };

            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Calculate,
                _cloudWatchSettings.FunctionVersion, instanceTotal, FunctionInstanceType.CalculateRunning, instanceNumber,
                model);

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> CalculateFinish(int scenarioId, int instanceTotal, int instanceNumber, long productTotal, long productCount, double productRate, long recommendationCount, int hierarchyErrorCount)
        {
            var model = new FunctionInstanceCalculateJson(_cloudWatchSettings)
            {
                ProductTotal = productTotal,
                ProductCount = productCount,
                ProductRate = productRate,
                RecommendationCount = recommendationCount,
                HierarchyErrorCount = hierarchyErrorCount
            };

            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Calculate,
                _cloudWatchSettings.FunctionVersion, instanceTotal, FunctionInstanceType.CalculateFinished, instanceNumber,
                model);

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> CalculateError(int scenarioId, int instanceTotal, int instanceNumber, string errorMessage)
        {
            var model = new FunctionInstanceCalculateJson(_cloudWatchSettings)
            {
                ErrorMessage = errorMessage
            };

            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Calculate,
                _cloudWatchSettings.FunctionVersion, instanceTotal, FunctionInstanceType.CalculateError, instanceNumber, model);

            return SmFunctionGroupSummary.Build(result);
        }

        //
        // Upload
        //
        public async Task<SmFunctionGroupSummary> UploadStart(int scenarioId)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Upload,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.UploadStarting, 1,
                new FunctionInstanceUploadJson(_cloudWatchSettings));

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> UploadUpdate(int scenarioId)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Upload,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.UploadRunning, 1,
                new FunctionInstanceUploadJson(_cloudWatchSettings));

            return SmFunctionGroupSummary.Build(result);
        }
        public async Task<SmFunctionGroupSummary> UploadFinish(int scenarioId)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Upload,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.UploadFinished, 1,
                new FunctionInstanceUploadJson(_cloudWatchSettings));

            return SmFunctionGroupSummary.Build(result);
        }

        public async Task<SmFunctionGroupSummary> UploadError(int scenarioId, string errorMessage)
        {
            var result = await _functionRepository.Update(scenarioId, FunctionType.Markdown, FunctionGroupType.Upload,
                _cloudWatchSettings.FunctionVersion, 1, FunctionInstanceType.UploadError, 1,
                new FunctionInstanceUploadJson(_cloudWatchSettings)
                {
                    ErrorMessage = errorMessage
                });

            return SmFunctionGroupSummary.Build(result);
        }
    }
}
