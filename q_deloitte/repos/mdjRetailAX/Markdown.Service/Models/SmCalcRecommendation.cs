using System.Diagnostics;
using System.Collections.Generic;

using Markdown.Common.Enums;

namespace Markdown.Service.Models
{
    [DebuggerDisplay("{ScheduleId}: TotalRevenue={TotalRevenue.ToString(\"0.0000\")}, TerminalStock={TerminalStock}")]
    public struct SmCalcRecommendation
    {
        public int ScheduleId { get; set; }
        public int ScheduleMask { get; set; }
        public int ScheduleMarkdownCount { get; set; }
		public bool IsCsp { get; set; }
        public decimal[] PricePath { get; set; }
        public int RevisionId { get; set; }

        public int Rank { get; set; }
        public int TotalMarkdownCount { get; set; }
        public int TerminalStock { get; set; }
        public decimal TotalRevenue { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalMarkdownCost { get; set; }
        public decimal? FinalDiscount { get; set; }
        public decimal StockValue { get; set; }
        public decimal EstimatedProfit { get; set; }
		public decimal EstimatedSales { get; set; }
        public decimal SellThroughRate { get; set; }
        public decimal SellThroughTarget { get; set; }
        public MarkdownType FinalMarkdownType { get; set; }

        public List<SmCalcRecommendationProjection> Projections { get; set; }

        public SmCalcRecommendation(SmScenario scenario, SmDenseSchedule schedule, decimal[] pricePath, int revisionId, bool isCsp = false)
        {
            ScheduleId = schedule.ScheduleNumber;
            ScheduleMask = scenario.ScheduleMask;
            ScheduleMarkdownCount = schedule.MarkdownCount;

            IsCsp = isCsp;
            PricePath = pricePath;
            RevisionId = revisionId;

            // Defaults
            Rank = 0;
            TotalMarkdownCount = 0;
            TerminalStock = 0;
            TotalRevenue = 0M;
            TotalCost = 0M;
            TotalMarkdownCost = 0M;
            FinalDiscount = null;
            StockValue = 0M;
            EstimatedProfit = 0M;
            EstimatedSales = 0M;
            SellThroughRate = 0M;
            SellThroughTarget = 0M;
            FinalMarkdownType = MarkdownType.None;
            
            Projections = new List<SmCalcRecommendationProjection>();
        }
    }
}
 