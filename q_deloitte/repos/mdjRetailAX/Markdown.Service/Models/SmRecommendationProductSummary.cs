using System;
using System.Linq;
using Markdown.Common.Enums;
using Markdown.Common.Filtering;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmRecommendationProductSummary
    {
        private SmRecommendationProductSummary()
        {
        }

        public Guid RecommendationProductGuid { get; set; }

        public int ClientId { get; set; }
        public int ScenarioId { get; set; }

        public int ModelId { get; set; }
        public int ProductId { get; set; }
        public int PriceLadderId { get; set; }
        public string ProductName { get; set; }

        public int PartitionCount { get; set; }
        public int PartitionNumber { get; set; }

        public int HierarchyId { get; set; }
        public string HierarchyName { get; set; }

        public int RevisionCount { get; set; }

        public int ScheduleCount { get; set; }
        public int ScheduleCrossProductCount { get; set; }
        public int ScheduleProductMaskFilterCount { get; set; }
        public int ScheduleMaxMarkdownFilterCount { get; set; }

        public int HighPredictionCount { get; set; }
        public int NegativeRevenueCount { get; set; }
        public int InvalidMarkdownTypeCount { get; set; }

        public int CurrentMarkdownCount { get; set; }
        public MarkdownType CurrentMarkdownType { get; set; }
        public decimal CurrentSellingPrice { get; set; }
        public decimal OriginalSellingPrice { get; set; }
        public decimal CurrentCostPrice { get; set; }
        public int CurrentStock { get; set; }
        public int CurrentSalesQuantity { get; set; }

        public decimal SellThroughTarget { get; set; }

        public decimal CurrentMarkdownDepth { get; set; }
        public decimal? CurrentDiscountLadderDepth { get; set; }

        public ProductState State { get; set; }
        public DecisionState DecisionState { get; set; }

        public SmRecommendationSummary Recommendation { get; set; }
        public SmRecommendationSummary CspRecommendation { get; set; }
        public SmRecommendationSummary RevRecommendation { get; set; }

        public SmRecommendationSummary DecisionRecommendation { get; set; }

        public static SmRecommendationProductSummary Build(RecommendationProductSummary entity)
        {
            if (entity == null)
                return null;

            return new SmRecommendationProductSummary
            {
                RecommendationProductGuid = entity.RecommendationProductGuid,

                ClientId = entity.ClientId,
                ScenarioId = entity.ScenarioId,

                ModelId = entity.ModelId,
                ProductId = entity.ProductId,
                PriceLadderId = entity.PriceLadderId,
                ProductName = entity.ProductName,

                PartitionNumber = entity.PartitionNumber,
                PartitionCount = entity.PartitionCount,

                HierarchyId = entity.HierarchyId,
                HierarchyName = entity.HierarchyName,

                RevisionCount = entity.RevisionCount,

                ScheduleCount = entity.ScheduleCount,
                ScheduleCrossProductCount = entity.ScheduleCrossProductCount,
                ScheduleProductMaskFilterCount = entity.ScheduleProductMaskFilterCount,
                ScheduleMaxMarkdownFilterCount = entity.ScheduleMaxMarkdownFilterCount,

                HighPredictionCount = entity.HighPredictionCount,
                NegativeRevenueCount = entity.NegativeRevenueCount,
                InvalidMarkdownTypeCount = entity.InvalidMarkdownTypeCount,

                CurrentMarkdownCount = entity.CurrentMarkdownCount,
                CurrentMarkdownType = (MarkdownType)entity.CurrentMarkdownTypeId,
                CurrentSellingPrice = entity.CurrentSellingPrice,
                OriginalSellingPrice = entity.OriginalSellingPrice,
                CurrentCostPrice = entity.CurrentCostPrice,
                CurrentStock = entity.CurrentStock,
                CurrentSalesQuantity = entity.CurrentSalesQuantity,

                SellThroughTarget = entity.SellThroughTarget,

                CurrentMarkdownDepth = entity.CurrentMarkdownDepth,
                CurrentDiscountLadderDepth = entity.CurrentDiscountLadderDepth,

                State = entity.State,
                DecisionState = entity.DecisionState,

                Recommendation = SmRecommendationSummary.Build(entity.Recommendation),
                CspRecommendation = SmRecommendationSummary.Build(entity.CspRecommendation),
                RevRecommendation = SmRecommendationSummary.Build(entity.RevRecommendation),
                DecisionRecommendation = SmRecommendationSummary.Build(entity.DecisionRecommendation)
            };
        }

        public static QueryResults<SmRecommendationProductSummary> Build(QueryResults<RecommendationProductSummary> queryResults)
        {
            var items = queryResults?.Items?.Select(Build).ToList();

            return new QueryResults<SmRecommendationProductSummary>
            {
                Items = items,
                PageIndex = queryResults?.PageIndex ?? 0,
                PageSize = queryResults?.PageSize ?? 0,
                Total = queryResults?.Total ?? 0
            };
        }
    }
}