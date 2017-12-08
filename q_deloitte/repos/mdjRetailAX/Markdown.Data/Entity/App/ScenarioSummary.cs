using System;
using System.ComponentModel.DataAnnotations.Schema;
using Markdown.Common.Enums;

namespace Markdown.Data.Entity.App
{
    public class ScenarioSummary : IBaseEntity
    {
        [ForeignKey("Scenario")]
        public int ScenarioId { get; set; }
		public int OrganisationId { get; set; }
        public string ScenarioName { get; set; }
        public ScenarioSummaryStatusType ScenarioSummaryStatusTypeId { get; set; }
        public string ScenarioSummaryStatusTypeName { get; set; }
        public int? LastFunctionInstanceId { get; set; }
        public int LastGroupTypeId { get; set; }
        public string LastGroupTypeName { get; set; }
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
        public DateTime? LastRunDateWithoutTime { get; set; }

        //New scenario list elements
        public decimal ProductsCost { get; set; }
        public decimal ProductsAcceptedCost { get; set; }
        public int ProductsAcceptedCount { get; set;}
        public int ProductsRejectedCount { get; set;}
        public int ProductsRevisedCount { get; set;}
		public decimal ProductsAcceptedPercentage { get; set; }
		public decimal ProductsRejectedPercentage { get; set; }
		public decimal ProductsRevisedPercentage { get; set; }
        public decimal ProductsEstimatedProfit { get; set;}
        public decimal ProductsEstimatedSales { get; set;}
        public decimal ProductsAverageDepth { get; set;}
        public decimal ProductsMarkdownCost { get; set;}
        public int ProductsTerminalStock { get; set;}

        public virtual Scenario Scenario { get; set; }
    }
}
