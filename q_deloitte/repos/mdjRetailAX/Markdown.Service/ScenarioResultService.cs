using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;

using Murmur;

using Markdown.Common.Settings;

using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef;
using Markdown.Data.Repository.S3;

using Markdown.Service.Models;


namespace Markdown.Service
{
    public interface IScenarioResultService
    {
        Task<List<SmCalcProduct>> Load(IMarkdownFunctionSettings settings, int clientId, int scenarioId, int partitionId, int partitionCount);
        Task Upload(IMarkdownFunctionSettings settings, int clientId,int userId, int scenarioId, int partitionId, int partitionCount, List<SmCalcProduct> results);
        Task Upload(IMarkdownFunctionSettings settings, SmRecommendationProductSummary product, int revisionId, List<SmCalcRecommendation> recommendations,int userId);
    }

    public class ScenarioResultService : IScenarioResultService
    {
        private readonly IS3Repository _s3Repository;
        private readonly IRecommendationRepository _recommendationRepository;
        private readonly IRecommendationProductRepository _recommendationProductRepository;

        public ScenarioResultService(IS3Repository s3Repository, IRecommendationRepository recommendationRepository, IRecommendationProductRepository recommendationProductRepository)
        {
            _s3Repository = s3Repository;
            _recommendationRepository = recommendationRepository;
            _recommendationProductRepository = recommendationProductRepository;
        }

        public async Task<List<SmCalcProduct>> Load(IMarkdownFunctionSettings settings, int clientId, int scenarioId, int partitionId, int partitionCount)
        {
            var isOptional = partitionId > 1;
            var path = SmS3Path.ScenarioPartitionPath(SmS3PathName.Output, settings.S3ScenarioBucketName, settings.S3ScenarioPartitionTemplate, scenarioId, partitionId, partitionCount);
            return await _s3Repository.ReadRecords<SmCalcProduct>(path, isOptional);
        }

        public async Task Upload(IMarkdownFunctionSettings settings, SmRecommendationProductSummary product, int revisionId, List<SmCalcRecommendation> recommendations, int userId)
        {
            var seededHash = MurmurHash.Create128(seed: (uint)product.ClientId);
            var entities = Build(seededHash, product, recommendations, userId);
            await _recommendationRepository.Write(clientId: product.ClientId, scenarioId: product.ScenarioId, revisionId: revisionId, partitionId: product.PartitionNumber, productId: product.ProductId, entities: entities);
        }

        public async Task Upload(IMarkdownFunctionSettings settings, int clientId,int userId, int scenarioId, int partitionId, int partitionCount, List<SmCalcProduct> results)
        {
            var seededHash = MurmurHash.Create128(seed: (uint)clientId);
            var entities = Build(seededHash, partitionId, partitionCount, results, userId);
            await _recommendationProductRepository.Write(clientId: clientId, scenarioId: scenarioId, partitionId: partitionId, entities: entities);
        }

        private static List<RecommendationProduct> Build(Murmur128 hash, int partitionId, int partitionCount, List<SmCalcProduct> products, int userId)

        {
            var entities = new List<RecommendationProduct>();

            foreach (var product in products)
            {
                var productEntity = new RecommendationProduct(hash)
                {
                    
                    ClientId = product.ClientId,
                    ScenarioId = product.ScenarioId,

                    ModelId = product.ModelId,
                    ProductId = product.ProductId,
                    ProductName = product.ProductName,
                    PriceLadderId = product.PriceLadderId,

                    PartitionNumber = partitionId,
                    PartitionCount = partitionCount,

                    HierarchyId = product.HierarchyId,
                    HierarchyName = product.HierarchyName,

                    ScheduleCount = product.ScheduleCount,
                    ScheduleCrossProductCount = product.ScheduleCrossProductCount,
                    ScheduleProductMaskFilterCount = product.ScheduleProductMaskFilterCount,
                    ScheduleMaxMarkdownFilterCount = product.ScheduleMaxMarkdownFilterCount,

                    HighPredictionCount = product.HighPredictionCount,
                    NegativeRevenueCount = product.NegativeRevenueCount,
                    InvalidMarkdownTypeCount = product.InvalidMarkdownTypeCount,

                    CurrentMarkdownCount = product.CurrentMarkdownCount,
                    CurrentMarkdownTypeId = (int)product.CurrentMarkdownType,
                    CurrentSellingPrice = product.CurrentSellingPrice,
                    OriginalSellingPrice = product.OriginalSellingPrice,
                    CurrentCostPrice = product.CurrentCostPrice,
                    CurrentStock = product.CurrentStock,
                    CurrentSalesQuantity = product.CurrentSalesQuantity,
                    SellThroughTarget = product.SellThroughTarget,
                    CurrentMarkdownDepth = product.CurrentMarkdownDepth,
                    CurrentDiscountLadderDepth = product.CurrentDiscountLadderDepth,

                    StateName = product.State.ToString(),
                    DecisionStateName = product.DecisionState.ToString(),
                    CreatedBy = userId
                };

                foreach (var recommendation in product.Recommendations)
                {
                    var recommendationEntity = new Recommendation(hash)
                    {
                        ClientId = product.ClientId,
                        ScenarioId = product.ScenarioId,

                        ScheduleId = recommendation.ScheduleId,
                        ScheduleMask = recommendation.ScheduleMask,
                        ScheduleMarkdownCount = recommendation.ScheduleMarkdownCount,
                        IsCsp = recommendation.IsCsp,
                        PricePathPrices = string.Join(";", recommendation.PricePath),
                        PricePathHashCode = string.Join(";", recommendation.PricePath).GetHashCode(),
                        RevisionId = recommendation.RevisionId,

                        Rank = recommendation.Rank,
                        TotalMarkdownCount = recommendation.TotalMarkdownCount,
                        TerminalStock = recommendation.TerminalStock,
                        TotalRevenue = recommendation.TotalRevenue,
                        TotalCost = recommendation.TotalCost,
                        TotalMarkdownCost = recommendation.TotalMarkdownCost,
                        FinalDiscount = recommendation.FinalDiscount,
                        StockValue = recommendation.StockValue,
                        EstimatedProfit = recommendation.EstimatedProfit,
                        EstimatedSales = recommendation.EstimatedSales,
                        SellThroughRate = recommendation.SellThroughRate,
                        SellThroughTarget = recommendation.SellThroughTarget,
                        FinalMarkdownTypeId = (int)recommendation.FinalMarkdownType,

                        Product = productEntity,
						CreatedBy = userId
                    };

                    recommendationEntity.Projections = recommendation
                        .Projections
                        .Select(x => new RecommendationProjection(hash)
                        {
                            ClientId = product.ClientId,
                            ScenarioId = product.ScenarioId,

                            Week = x.Week,
                            Discount = x.Discount,
                            Price = x.Price,
                            Quantity = x.Quantity,
                            Revenue = x.Revenue,
                            Stock = x.Stock,
                            MarkdownCost = x.MarkdownCost,
                            AccumulatedMarkdownCount = x.AccumulatedMarkdownCount,
                            MarkdownCount = x.MarkdownCount,
                            Elasticity = x.Elasticity,
                            Decay = x.Decay,
                            MarkdownTypeId = (int)x.MarkdownType,

                            Recommendation = recommendationEntity
                        })
                        .ToList();

                    productEntity.Recommendations.Add(recommendationEntity);
                }

                entities.Add(productEntity);
            }

            return entities;
        }

        private static List<Recommendation> Build(Murmur128 hash, SmRecommendationProductSummary product, IEnumerable<SmCalcRecommendation> recommendations, int userId)

        {
            var results = new List<Recommendation>();

            foreach (var recommendation in recommendations)
            {
                var recommendationEntity = new Recommendation(hash)
                {
                    ClientId = product.ClientId,
                    ScenarioId = product.ScenarioId,

                    ScheduleId = recommendation.ScheduleId,
                    ScheduleMask = recommendation.ScheduleMask,
                    ScheduleMarkdownCount = recommendation.ScheduleMarkdownCount,
                    IsCsp = recommendation.IsCsp,
                    PricePathPrices = string.Join(";", recommendation.PricePath),
                    PricePathHashCode = string.Join(";", recommendation.PricePath).GetHashCode(),
                    RevisionId = recommendation.RevisionId,

                    Rank = recommendation.Rank,
                    TotalMarkdownCount = recommendation.TotalMarkdownCount,
                    TerminalStock = recommendation.TerminalStock,
                    TotalRevenue = recommendation.TotalRevenue,
                    TotalCost = recommendation.TotalCost,
                    TotalMarkdownCost = recommendation.TotalMarkdownCost,
                    FinalDiscount = recommendation.FinalDiscount,
                    StockValue = recommendation.StockValue,
                    EstimatedProfit = recommendation.EstimatedProfit,
                    EstimatedSales = recommendation.EstimatedSales,
                    SellThroughRate = recommendation.SellThroughRate,
                    SellThroughTarget = recommendation.SellThroughTarget,
                    FinalMarkdownTypeId = (int)recommendation.FinalMarkdownType,

                    RecommendationProductGuid = product.RecommendationProductGuid,
					CreatedBy = userId
                };

                recommendationEntity.Projections = recommendation
                    .Projections
                    .Select(x => new RecommendationProjection(hash)
                    {
                        ClientId = product.ClientId,
                        ScenarioId = product.ScenarioId,

                        Week = x.Week,
                        Discount = x.Discount,
                        Price = x.Price,
                        Quantity = x.Quantity,
                        Revenue = x.Revenue,
                        Stock = x.Stock,
                        MarkdownCost = x.MarkdownCost,
                        AccumulatedMarkdownCount = x.AccumulatedMarkdownCount,
                        MarkdownCount = x.MarkdownCount,
                        Elasticity = x.Elasticity,
                        Decay = x.Decay,
                        MarkdownTypeId = (int)x.MarkdownType,

                        Recommendation = recommendationEntity
                    })
                    .ToList();

                results.Add(recommendationEntity);
            }

            return results;
        }
    }
}
