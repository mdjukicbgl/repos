using System;
using System.ComponentModel.DataAnnotations.Schema;

using Markdown.Common.Enums;
using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class RecommendationProductSummary : IBaseEntity
    {
        [Key]
        public Guid RecommendationProductSummaryGuid { get; set; }
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
        public int CurrentMarkdownTypeId { get; set; }
        public decimal CurrentSellingPrice { get; set; }
        public decimal OriginalSellingPrice { get; set; }
        public decimal CurrentCostPrice { get; set; }
        public int CurrentStock { get; set; }
        public int CurrentSalesQuantity { get; set; }

        public decimal SellThroughTarget { get; set; }

        public decimal CurrentMarkdownDepth { get; set; }
        public decimal? CurrentDiscountLadderDepth { get; set; }

        public string StateName { get; set; }
        public string DecisionStateName { get; set; }

        [NotMapped]
        public ProductState State => (ProductState)Enum.Parse(typeof(ProductState), StateName);

        [NotMapped]
        public DecisionState DecisionState => (DecisionState)Enum.Parse(typeof(DecisionState), DecisionStateName);

        [ForeignKey("Recommendation")]
        public virtual Guid? RecommendationGuid { get; set; }
        public virtual RecommendationSummary Recommendation { get; set; }

        [ForeignKey("CspRecommendation")]
        public virtual Guid? CspRecommendationGuid { get; set; }
        public virtual RecommendationSummary CspRecommendation { get; set; }

        [ForeignKey("RevRecommendation")]
        public virtual Guid? RevRecommendationGuid { get; set; }
        public virtual RecommendationSummary RevRecommendation { get; set; }

        [ForeignKey("DecisionRecommendation")]
        public virtual Guid? DecisionRecommendationGuid { get; set; }
        public virtual RecommendationSummary DecisionRecommendation { get; set; }
    }
}