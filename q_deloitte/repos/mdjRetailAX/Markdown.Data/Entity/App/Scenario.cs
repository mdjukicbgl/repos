using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Markdown.Common.Enums;

namespace Markdown.Data.Entity.App
{
    public class Scenario : IBaseEntity
    {
        [Key]
        public int ScenarioId { get; set; }
        public int OrganisationId { get; set; }
        public string ScenarioName { get; set; }
        public int? Week { get; set; }
        public int ScheduleMask { get; set; }
        public int ScheduleWeekMin { get; set; }
        public int ScheduleWeekMax { get; set; }
        public int ScheduleStageMin { get; set; }
        public int ScheduleStageMax { get; set; }
        public int? StageMax { get; set; }
        public int? StageOffsetMax { get; set; }
        public decimal? PriceFloor { get; set; }
        public int MarkdownCountStartWeek { get; set; }
        public int DefaultMarkdownType { get; set; }
        public string DefaultDecisionStateName { get; set; } = DecisionState.Neutral.ToString();
        public bool AllowPromoAsMarkdown { get; set; }
        public decimal MinimumPromoPercentage { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public int CreatedBy{ get; set; }
        public int? UpdatedBy { get; set; }

        [NotMapped]
        public DecisionState DefaultDecisionState => (DecisionState)Enum.Parse(typeof(DecisionState), DefaultDecisionStateName ?? DecisionState.Neutral.ToString());
    }
}