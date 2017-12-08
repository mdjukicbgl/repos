using Markdown.Common.Settings;
using Markdown.Data.Entity.App;
using Markdown.Data.Entity.Ephemeral;
using Markdown.Data.Repository.S3;
using Markdown.Service.Models;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using PriceLadderValue = Markdown.Data.Entity.Ephemeral.PriceLadderValue;

namespace Markdown.Service
{
    public interface IScenarioService
    {
        Task<SmModelData> GetModelData(IMarkdownFunctionSettings settings);
        Task<Tuple<SmScenario, List<SmProduct>>> GetScenarioData(IMarkdownFunctionSettings settings, int partitionId, IEnumerable<int> specificProductIds = null);
    }

    public class ScenarioService : IScenarioService
    {
        private readonly ILogger _logger;
        private readonly IS3Repository _s3Repository;

        public ScenarioService(ILogger logger, IS3Repository s3Repository)
        {
            _logger = logger;
            _s3Repository = s3Repository;
        }

        public async Task<SmModelData> GetModelData(IMarkdownFunctionSettings settings)
        {
            var elasticityPath = SmS3Path.ModelPath(SmS3PathName.ElasticityHierarchy, settings);
            var elasticity = await _s3Repository.ReadRecords<ElasticityHierarchy>(elasticityPath);

            var decayPath = SmS3Path.ModelPath(SmS3PathName.DecayHierarchy, settings);
            var decay = await _s3Repository.ReadRecords<DecayHierarchy>(decayPath);

            return SmModelData.Build(elasticity, decay);
        }

        public async Task<Tuple<SmScenario, List<SmProduct>>> GetScenarioData(IMarkdownFunctionSettings settings, int partitionId, IEnumerable<int> specificProductIds = null)
        {
            var isOptional = partitionId > 1;

            // Scenario
            var scenarioPath = SmS3Path.ScenarioPath(SmS3PathName.Scenario, settings);
            var scenario = await _s3Repository.ReadRecord<Scenario>(scenarioPath);

            var sellThroughPath = SmS3Path.ScenarioPath(SmS3PathName.HierarchySellThrough, settings);
            var sellThrough = await _s3Repository.ReadRecords<HierarchySellThrough>(sellThroughPath);
            if (!sellThrough.Any())
                _logger.Warning("No sell through targets in partition");

            var priceLadderValuePath = SmS3Path.ScenarioPath(SmS3PathName.PriceLadderValue, settings);
            var priceLadderValue = await _s3Repository.ReadRecords<PriceLadderValue>(priceLadderValuePath);
            if (!priceLadderValue.Any())
                _logger.Error("No price ladder values in partition");

            // Product
            var productPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.Product, settings);
            var product = await _s3Repository.ReadRecords<Product>(productPath, isOptional);
            if (specificProductIds != null)
                product = product.Where(x => specificProductIds.Contains(x.ProductId)).ToList();
            if (!product.Any())
                _logger.Error("No products in partition");

            var productHierarchyPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductHierarchy, settings);
            var productHierarchy = await _s3Repository.ReadRecords<ProductHierarchy>(productHierarchyPath, isOptional);
            if (!productHierarchy.Any())
                _logger.Error("No product hierarchies in partition");

            var productPriceLadderPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductPriceLadder, settings);
            var productPriceLadder = await _s3Repository.ReadRecords<ProductPriceLadder>(productPriceLadderPath, isOptional);
            if (!productPriceLadder.Any())
                _logger.Error("No product price ladders in partition");

            var productSalesTaxPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductSalesTax, settings);
            var productSalesTax = await _s3Repository.ReadRecords<ProductSalesTax>(productSalesTaxPath, isOptional);
            if (!productSalesTax.Any())
                _logger.Warning("No product sales tax in partition");

            var productParameterValuesPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductParameterValues, settings);
            var productParameterValues = await _s3Repository.ReadRecords<ProductParameterValues>(productParameterValuesPath, isOptional);
            if (!productParameterValues.Any())
                _logger.Warning("No product parameter values in partition");

            var productMarkdownConstraintPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductMarkdownConstraint, settings);
            var productMarkdownConstraint = await _s3Repository.ReadRecords<ProductMarkdownConstraint>(productMarkdownConstraintPath, true);
            if (!productMarkdownConstraint.Any())
                _logger.Warning("No product markdown constraint values in partition");

            var salesFlexFactorPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.SalesFlexFactor, settings);
            var salesFlexFactor = await _s3Repository.ReadRecords<ProductSalesFlexFactor>(salesFlexFactorPath, isOptional);
            if (!salesFlexFactor.Any())
                _logger.Warning("No sales flex factor values in partition");

            var productMinimumAbsolutePriceChangePath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductMinimumAbsolutePriceChange, settings);
            var productMinimumAbsolutePriceChange = await _s3Repository.ReadRecords<ProductMinimumAbsolutePriceChange>(productMinimumAbsolutePriceChangePath, true);
            if (!productMinimumAbsolutePriceChange.Any())
                _logger.Warning("No product minimum absolute price change values in partition");

            var productWeekParameterValuesPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductWeekParameterValues, settings);
            var productWeekParameterValues = await _s3Repository.ReadRecords<ProductWeekParameterValues>(productWeekParameterValuesPath, true);
            if (!productWeekParameterValues.Any())
                _logger.Warning("No product week parameter values in partition");

            var productWeekMarkdownTypeParameterValuesPath = SmS3Path.ScenarioPartitionPath(SmS3PathName.ProductWeekMarkdownTypeParameterValues, settings);
            var productWeekMarkdownTypeParameterValues = await _s3Repository.ReadRecords<ProductWeekMarkdownTypeParameterValues>(productWeekMarkdownTypeParameterValuesPath, true);
            if (!productWeekMarkdownTypeParameterValues.Any())
                _logger.Warning("No product week parameter values in partition");

            // Sell through lookup
            var sellThroughLookup = sellThrough.Any() ? sellThrough.ToDictionary(x => x.HierarchyId, x => x.Value) : new Dictionary<int, decimal>();

            // Sales tax lookup
            var productSalesTaxLookup =
                productSalesTax.Any()
                    ? productSalesTax.ToDictionary(x => x.ProductId, x => Tuple.Create(x.Week, x.Rate))
                    : new Dictionary<int, Tuple<int, decimal>>();

            var products = SmProduct.Build(_logger, product, productHierarchy, productPriceLadder, priceLadderValue,
                sellThroughLookup, productSalesTaxLookup, productParameterValues, productMarkdownConstraint, salesFlexFactor, productMinimumAbsolutePriceChange, productWeekParameterValues, productWeekMarkdownTypeParameterValues);

            return Tuple.Create(SmScenario.Build(scenario), products);
        }
    }
}
