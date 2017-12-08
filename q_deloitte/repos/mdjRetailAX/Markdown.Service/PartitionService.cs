using System;
using System.Linq;
using System.Diagnostics;
using System.Threading.Tasks;
using Serilog;

using Markdown.Common.Extensions;
using Markdown.Common.Settings;
using Markdown.Data.Entity.App;
using Markdown.Data.Entity.Ephemeral;
using Markdown.Data.Repository.Ef;
using Markdown.Data.Repository.S3;
using Markdown.Service.Models;

using PriceLadderValue = Markdown.Data.Entity.Ephemeral.PriceLadderValue;

namespace Markdown.Service
{
    public interface IPartitionService
    {
        Task Split(IMarkdownFunctionSettings settings, int week, int scheduleWeekMin, int scheduleWeekMax,  int markdownCountStartWeek, bool allowPromoAsMarkdown, decimal minimumPromoPercentage);
    }

    public class PartitionService : IPartitionService
    {
        private readonly ILogger _logger;
        private readonly IS3Repository _s3Repository;
        private readonly IEphemeralRepository _ephemeralRepository;
        private readonly IScenarioSummaryRepository _scenarioSummaryRepository;

        public PartitionService(ILogger logger, IS3Repository s3Repository, IEphemeralRepository ephemeralRepository, IScenarioSummaryRepository scenarioSummaryRepository)
        {
            _logger = logger.ForContext<PartitionService>();
            _s3Repository = s3Repository;
            _ephemeralRepository = ephemeralRepository;
            _scenarioSummaryRepository = scenarioSummaryRepository;
        }

        public async Task Split(IMarkdownFunctionSettings settings, int week, int scheduleWeekMin, int scheduleWeekMax, int markdownCountStartWeek, bool allowPromoAsMarkdown, decimal minimumPromoPercentage)
        {
            _logger.Information("Deleting old partition records");

            var scenarioBasePath = SmS3Path.ScenarioPath(SmS3PathName.ScenarioBase, settings);
            await _s3Repository.DeletePath(scenarioBasePath);

            _logger.Information("Updating partition records");
            var productTotals = new int[settings.PartitionCount];
            
            await _ephemeralRepository.GetScenarioData(settings.ModelRunId, settings.ScenarioId, week, scheduleWeekMin, scheduleWeekMax, markdownCountStartWeek,
                settings.PartitionCount, allowPromoAsMarkdown, minimumPromoPercentage, async reader =>
                {
                    _logger.Information("Writing common data to S3");

                    var header = reader.Read<ScenarioHeader>().Single();
                    var headerPath = SmS3Path.ScenarioPath(SmS3PathName.ScenarioHeader, settings);
                    await _s3Repository.WriteRecord(headerPath, header);

                    var scenarioPath = SmS3Path.ScenarioPath(SmS3PathName.Scenario, settings);
                    var scenario = reader.Read<Scenario>().Single();
                    await _s3Repository.WriteRecord(scenarioPath, scenario);

                    var priceLadderValues = reader.Read<PriceLadderValue>().ToList();
                    var priceLadderValuePath = SmS3Path.ScenarioPath(SmS3PathName.PriceLadderValue, settings);
                    await _s3Repository.WriteRecords(priceLadderValuePath, priceLadderValues);

                    var hierarchy = reader.Read<Hierarchy>().ToList();
                    var hierarchyPath = SmS3Path.ScenarioPath(SmS3PathName.Hierarchy, settings);
                    await _s3Repository.WriteRecords(hierarchyPath, hierarchy);

                    var hierarchySellThrough = reader.Read<HierarchySellThrough>().ToList();
                    var hierarchySellThroughPath = SmS3Path.ScenarioPath(SmS3PathName.HierarchySellThrough, settings);
                    await _s3Repository.WriteRecords(hierarchySellThroughPath, hierarchySellThrough);

                    _logger.Information("Writing partition data to S3");

                    var products = reader.Read<Product>().ChunkBy(x => x.PartitionNumber).ToList();
                    if (!products.Any())
                        throw new Exception("GetScenarioData returned no products");

                    foreach (var chunk in products)
                    {
                        productTotals[chunk.Key - 1] = chunk.Count();
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.Product, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductHierarchy>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductHierarchy, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductPriceLadder>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductPriceLadder, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductSalesTax>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductSalesTax, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductParameterValues>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductParameterValues, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductMarkdownConstraint>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductMarkdownConstraint, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductSalesFlexFactor>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.SalesFlexFactor, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductMinimumAbsolutePriceChange>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductMinimumAbsolutePriceChange, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductWeekParameterValues>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductWeekParameterValues, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    foreach (var chunk in reader.Read<ProductWeekMarkdownTypeParameterValues>().ChunkBy(x => x.PartitionNumber))
                    {
                        var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductWeekMarkdownTypeParameterValues, settings, chunk.Key);
                        await _s3Repository.WriteRecords(path, chunk);
                    }

                    var workingSet64 = Process.GetCurrentProcess().WorkingSet64;
                    _logger.Debug("Wrote scenario data. Working Set is {Size} ({Bytes})",
                        workingSet64.ToOrdinalString(), workingSet64);
                });

            _logger.Information("Split complete");
        }
    }
}
