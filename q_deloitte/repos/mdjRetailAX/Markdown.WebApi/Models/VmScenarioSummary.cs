using System;
using System.Linq;
using System.Collections.Generic;

using Markdown.Common.Enums;
using Markdown.Common.Filtering;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmScenarioSummary : VmScenario
    {
        public double? Duration { get; set; }

        public int? PartitionTotal { get; set; }
        public int? PartitionCount { get; set; }
        public int? PartitionErrorCount { get; set; }
        public int? PartitionSuccessCount { get; set; }
        
        public ScenarioSummaryStatusType Status { get; set; }
        public DateTime? LastRunDate { get; set; }

        public long? TotalNumberRecommendedProducts { get; set; }
        public long? RecommendationCount { get; set; }

		public decimal ProductsCost { get; set; }
		public decimal ProductsAcceptedCost { get; set; }
		public int ProductsAcceptedCount { get; set; }
		public int ProductsRejectedCount { get; set; }
		public int ProductsRevisedCount { get; set; }
		public decimal ProductsAcceptedPercentage { get; set; }
		public decimal ProductsRejectedPercentage { get; set; }
		public decimal ProductsRevisedPercentage { get; set; }
		public decimal EstimatedProfitAmount { get; set; }
		public decimal EstimatedSalesUnits { get; set; }
		public decimal AverageDiscount { get; set; }
		public decimal MarkdownCost { get; set; }
		public int TerminalStockUnits { get; set; }

        public static VmScenarioSummary Build(SmScenarioSummary model)
        {
            var scenario = VmScenario.Build(model.Scenario);

            return new VmScenarioSummary
            {
                // Scenario
                ScenarioId = model.ScenarioId,
                ScenarioName = scenario.ScenarioName,
                Week = scenario.Week,
                ScheduleWeekMin = scenario.ScheduleWeekMin,
                ScheduleWeekMax = scenario.ScheduleWeekMax,
                ScheduleStageMin = scenario.ScheduleStageMin,
                ScheduleStageMax = scenario.ScheduleStageMax,
                StageMax = scenario.StageMax,
                StageOffsetMax = scenario.StageOffsetMax,
                PriceFloor = scenario.PriceFloor,
                CustomerId = scenario.CustomerId,
                ScheduleMask = scenario.ScheduleMask,
                MarkdownCountStartWeek = scenario.MarkdownCountStartWeek,
                DefaultMarkdownType = scenario.DefaultMarkdownType,
                AllowPromoAsMarkdown = scenario.AllowPromoAsMarkdown,
                MinimumPromoPercentage = scenario.MinimumPromoPercentage,

                ProductsCost = model.ProductsCost,
				ProductsAcceptedCost = model.ProductsAcceptedCost,
                ProductsAcceptedCount = model.ProductsAcceptedCount,
                ProductsRejectedCount = model.ProductsRejectedCount,
                ProductsAcceptedPercentage = model.ProductsAcceptedPercentage,
                ProductsRejectedPercentage = model.ProductsRejectedPercentage,
                ProductsRevisedPercentage =  model.ProductsRevisedPercentage,
                ProductsRevisedCount = model.ProductsRevisedCount,
                EstimatedProfitAmount = model.ProductsEstimatedProfit,
                EstimatedSalesUnits = model.ProductsEstimatedSales,
                AverageDiscount = model.ProductsAverageDepth,
                MarkdownCost = model.ProductsMarkdownCost,
                TerminalStockUnits = model.ProductsTerminalStock,

                // Summary
                Status = model.Status,
                TotalNumberRecommendedProducts = model.ProductCount,
                RecommendationCount = model.RecommendationCount,
                Duration = model.Duration,
                PartitionCount = model.FunctionInstanceCount,
                PartitionTotal = model.FunctionInstanceCountTotal,
                PartitionErrorCount = model.ErrorCount,
                PartitionSuccessCount = model.SuccessCount,
                LastRunDate = model.LastRunDate
            };
        }

        public static List<VmScenarioSummary> Build(QueryResults<SmScenarioSummary> entities)
        {
            return entities?.Items?.Select(Build).ToList();
        }
    }
}