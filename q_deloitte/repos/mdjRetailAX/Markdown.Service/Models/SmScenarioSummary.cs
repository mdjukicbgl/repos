using System;
using System.Linq;
using System.Collections.Generic;
using Markdown.Common.Enums;
using Markdown.Data.Entity.App;
using Markdown.Common.Filtering;
using FunctionGroupType = Markdown.Common.Enums.FunctionGroupType;
using ScenarioSummaryStatusType = Markdown.Common.Enums.ScenarioSummaryStatusType;

namespace Markdown.Service.Models
{
    public class SmScenarioSummary
    {
        private SmScenarioSummary()
        {

        }

        public int ScenarioId { get; set; }
        public string ScenarioName { get; set; }

        public ScenarioSummaryStatusType Status { get; set; }

        public FunctionGroupType LastGroupType { get; set; }
        public int? LastFunctionInstanceId { get; set; }
        public int FunctionInstanceCount { get; set; }
        public int FunctionInstanceCountTotal { get; set; }

        public long ProductTotal { get; set; }
        public long ProductCount { get; set; }
        public long RecommendationCount { get; set; }

        public int AttemptCountMin { get; set; }
        public double AttemptCountAvg { get; set; }
        public int AttemptCountMax { get; set; }

        public double Duration { get; set; }

        public int SuccessCount { get; set; }
        public int ErrorCount { get; set; }
        public DateTime? LastRunDate { get; set; }

		//New scenario list elements
		public decimal ProductsCost { get; set; }
		public decimal ProductsAcceptedCost { get; set; }
		public int ProductsAcceptedCount { get; set; }
		public int ProductsRejectedCount { get; set; }
		public int ProductsRevisedCount { get; set; }
		public decimal ProductsAcceptedPercentage { get; set; }
		public decimal ProductsRejectedPercentage { get; set; }
		public decimal ProductsRevisedPercentage { get; set; }
		public decimal ProductsEstimatedProfit { get; set; }
		public decimal ProductsEstimatedSales { get; set; }
		public decimal ProductsAverageDepth { get; set; }
		public decimal ProductsMarkdownCost { get; set; }
		public int ProductsTerminalStock { get; set; }
        public int OrganisationId { get; set; }

        public SmScenario Scenario { get; set; }

        public static SmScenarioSummary Build(ScenarioSummary entity)
        {
            return new SmScenarioSummary
            {
                ScenarioId = entity.ScenarioId,
                ScenarioName = entity.ScenarioName,

                Status = (ScenarioSummaryStatusType)entity.ScenarioSummaryStatusTypeId,

                LastGroupType = (FunctionGroupType)entity.LastGroupTypeId,
                LastFunctionInstanceId = entity.LastFunctionInstanceId,
                FunctionInstanceCount = entity.FunctionInstanceCount,
                FunctionInstanceCountTotal = entity.FunctionInstanceCountTotal,

                ProductTotal = entity.ProductTotal,
                ProductCount = entity.ProductCount,
                RecommendationCount = entity.RecommendationCount,

                AttemptCountMin = entity.AttemptCountMin,
                AttemptCountAvg = entity.AttemptCountAvg,
                AttemptCountMax = entity.AttemptCountMax,

                Duration = entity.Duration,

                SuccessCount = entity.SuccessCount,
                ErrorCount = entity.ErrorCount,
                LastRunDate = entity.LastRunDate,

                //New scenario list elements
                ProductsCost = entity.ProductsCost,
                ProductsAcceptedCost = entity.ProductsAcceptedCost,
                ProductsAcceptedCount = entity.ProductsAcceptedCount,
                ProductsRejectedCount = entity.ProductsRejectedCount,
                ProductsRevisedCount = entity.ProductsRevisedCount,
				ProductsAcceptedPercentage = entity.ProductsAcceptedPercentage,
				ProductsRejectedPercentage = entity.ProductsRejectedPercentage,
				ProductsRevisedPercentage = entity.ProductsRevisedPercentage,
                ProductsEstimatedProfit = entity.ProductsEstimatedProfit,
                ProductsEstimatedSales = entity.ProductsEstimatedSales,
                ProductsAverageDepth = entity.ProductsAverageDepth,
                ProductsMarkdownCost = entity.ProductsMarkdownCost,
                ProductsTerminalStock = entity.ProductsTerminalStock,

                OrganisationId = entity.OrganisationId,
                Scenario = SmScenario.Build(entity.Scenario)
            };
        }

        public static List<SmScenarioSummary> Build(List<ScenarioSummary> entities)
        {
            return entities?.Select(Build).ToList();
        }

        public static QueryResults<SmScenarioSummary> Build(QueryResults<ScenarioSummary> queryResults)
        {
            if (queryResults == null)
                return new QueryResults<SmScenarioSummary>();

            return new QueryResults<SmScenarioSummary>
            {
                Items = queryResults.Items.Select(Build).ToList(),
                PageIndex = queryResults.PageIndex,
                PageSize = queryResults.PageSize,
                Total = queryResults.Total
            };
        }
    }
}