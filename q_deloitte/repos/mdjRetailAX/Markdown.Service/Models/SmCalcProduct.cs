using System.Diagnostics;
using System.Collections.Generic;
using Markdown.Common.Enums;

namespace Markdown.Service.Models
{
    [DebuggerDisplay("{ProductId}: {ProductName} Schedules={ScheduleCount} CSP={CurrentSellingPrice.ToString(\"0.0000\")} {State}/{DecisionState}")]
    public struct SmCalcProduct
    {
        public int ClientId { get; set; }
        public int ScenarioId { get; set; }
        public int ModelId { get; set; }
        public int ProductId { get; set; }
        public int PriceLadderId { get; set; }
        public string ProductName { get; set; }
        public int HierarchyId { get; set; }
        public string HierarchyName { get; set; }
        public List<SmCalcRecommendation> Recommendations { get; set; }

        public int ScheduleCount { get; set; }
        public int ScheduleCrossProductCount { get; set; }
        public int ScheduleProductMaskFilterCount { get; set; }
        public int ScheduleMaxMarkdownFilterCount { get; set; }
        public int ScheduleExceededFlowlineThresholdFilterCount { get; set; }

        public int HighPredictionCount { get; set; }
        public int NegativeRevenueCount { get; set; }
        public int InvalidMarkdownTypeCount { get; set; }
        public int MinimumAbsolutePriceChangeNotMetCount { get; set; }
        public int MinimumRelativePercentagePriceChangeNotMetCount { get; set; }
        public int DiscountPercentageOutsideAllowedRangeCount { get; set; }

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

        public decimal[] SalesFlexFactor { get; set; }
        public MarkdownType[] MarkdownTypeConstraint { get; set; }
        public decimal MinimumAbsolutePriceChange { get; set; }
        public decimal[] MinimumRelativePercentagePriceChange { get; set; }
        public decimal[] MinDiscountsNew { get; set; }
        public decimal[] MinDiscountsFurther { get; set; }
        public decimal[] MaxDiscountsNew { get; set; }
        public decimal[] MaxDiscountsFurther { get; set; }

        public ProductState State { get; set; }
        public DecisionState DecisionState { get; set; }


        public SmCalcProduct(SmScenario scenario, int modelId, SmProduct product, List<SmDenseSchedule> schedules, SmDepth depth)
        {
            ClientId = scenario.OrganisationId;
            ModelId = modelId;
            ScenarioId = scenario.ScenarioId;
            ProductId = product.ProductId;
            ProductName = product.Name;
            PriceLadderId = product.PriceLadder.PriceLadderId;

            Recommendations = new List<SmCalcRecommendation>();

            HierarchyId = product.HierarchyId;
            HierarchyName = product.HierarchyName;

            ScheduleCount = schedules.Count;
            ScheduleCrossProductCount = 0;
            ScheduleProductMaskFilterCount = 0;
            ScheduleMaxMarkdownFilterCount = 0;
            ScheduleExceededFlowlineThresholdFilterCount = 0;

            HighPredictionCount = 0;
            NegativeRevenueCount = 0;
            InvalidMarkdownTypeCount = 0;
            MinimumAbsolutePriceChangeNotMetCount = 0;
            MinimumRelativePercentagePriceChangeNotMetCount = 0;
            DiscountPercentageOutsideAllowedRangeCount = 0;

            CurrentMarkdownCount = product.CurrentMarkdownCount;
            CurrentMarkdownType = product.CurrentMarkdownType;
            CurrentSellingPrice = product.CurrentSellingPrice;
            OriginalSellingPrice = product.OriginalSellingPrice;
            CurrentCostPrice = product.CurrentCostPrice;
            CurrentStock = product.CurrentStock;
            CurrentSalesQuantity = product.CurrentSalesQuantity;
     
            SellThroughTarget = product.SellThrough;

            SalesFlexFactor = product.SalesFlexFactor;

            MarkdownTypeConstraint = product.MarkdownTypeConstraint;
            MinimumAbsolutePriceChange = product.MinimumAbsolutePriceChange;
            MinimumRelativePercentagePriceChange = product.MinimumRelativePercentagePriceChange;
            MinDiscountsNew = product.MinDiscountsNew;
            MinDiscountsFurther = product.MinDiscountsFurther;
            MaxDiscountsNew = product.MaxDiscountsNew;
            MaxDiscountsFurther = product.MaxDiscountsFurther;

            CurrentMarkdownDepth = depth.MarkdownDepth;
            CurrentDiscountLadderDepth = depth.DiscountLadderDepth;

            State = ProductState.Fatal;
            DecisionState = scenario.DefaultDecisionState;
        }

        public SmCalcProduct Ok()
        {
            State = ProductState.Ok;
            Recommendations = new List<SmCalcRecommendation>();
            return this;
        }

        public SmCalcProduct Ok(ProductState subState)
        {
            State = ProductState.Ok | subState;
            Recommendations = new List<SmCalcRecommendation>();
            return this;
        }

        public SmCalcProduct Ok(List<SmCalcRecommendation> recommendations)
        {
            State = ProductState.Ok;
            Recommendations = recommendations;
            return this;
        }

        public SmCalcProduct Fatal(ProductState subState)
        {
            State = ProductState.Fatal | subState;
            return this;
        }
    }
}