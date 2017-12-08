using System.Collections.Generic;
using System;
using System.Linq;
using Markdown.Data.Entity.App;
using Markdown.Common.Enums;

namespace Markdown.Service.Models
{
    public class SmScenario
    {
        public int ScenarioId { get; set; }
        public int OrganisationId { get; set; }
        public int? Week { get; set; }
        public int ScheduleWeekMin { get; set; }
        public int ScheduleWeekMax { get; set; }
        public int ScheduleStageMin { get; set; }
        public int ScheduleStageMax { get; set; }
        public int? StageMax { get; set; }
        public int? StageOffsetMax { get; set; }
        public decimal? PriceFloor { get; set; }
        public string ScenarioName { get; set; }
        public int ScheduleMask { get; set; }
        public int MarkdownCountStartWeek { get; set; }
        public int DefaultMarkdownType { get; set; }
        public DecisionState DefaultDecisionState { get; set; }
        public string DefaultDecisionStateName { get; set; }
        public bool AllowPromoAsMarkdown { get; set; }
        public decimal MinimumPromoPercentage { get; set; }
		public DateTime CreatedAt { get; set; }
		public DateTime? UpdatedAt { get; set; }
		public int CreatedBy { get; set; }
		public int? UpdatedBy { get; set; }


        public static SmScenario Build(Scenario entity)
        {
            if (entity == null)
                return null;

            return new SmScenario
            {
                ScenarioId = entity.ScenarioId,
                Week = entity.Week,
                ScheduleWeekMin = entity.ScheduleWeekMin,
                ScheduleWeekMax = entity.ScheduleWeekMax,
                ScheduleStageMin = entity.ScheduleStageMin,
                ScheduleStageMax = entity.ScheduleStageMax,
                StageMax = entity.StageMax,
                StageOffsetMax = entity.StageOffsetMax,
                PriceFloor = entity.PriceFloor,
                OrganisationId = entity.OrganisationId,
                ScenarioName = entity.ScenarioName,
                ScheduleMask = entity.ScheduleMask,
                MarkdownCountStartWeek = entity.MarkdownCountStartWeek,
                DefaultMarkdownType = entity.DefaultMarkdownType,
				DefaultDecisionState = entity.DefaultDecisionState,
                DefaultDecisionStateName = entity.DefaultDecisionStateName,
                AllowPromoAsMarkdown = entity.AllowPromoAsMarkdown,
                MinimumPromoPercentage = entity.MinimumPromoPercentage,
                CreatedAt = entity.CreatedAt,
                CreatedBy = entity.CreatedBy,
                UpdatedAt = entity.UpdatedAt,
                UpdatedBy = entity.UpdatedBy
            };
        }

        public static List<SmScenario> Build(List<Scenario> entities)
        {
            return entities?.Select(Build).ToList();
        }

        public static SmScenario Build(string name, int week, int scenarioMask, int scenarioWeekMin, 
                                       int scenarioWeekMax, int markdownCountStartWeek, int defaultMarkdownType,
                                       DecisionState defaultDecisionState,  bool allowPromoAsMarkdown, decimal minimumPromoPercentage,
                                       int organisationId, int userId)
        {
            return new SmScenario
            {
                ScenarioId = 0,
                Week = week,
                ScheduleWeekMin = scenarioWeekMin,
                ScheduleWeekMax = scenarioWeekMax,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                OrganisationId = organisationId,
                ScenarioName = name,
                ScheduleMask = scenarioMask,
                MarkdownCountStartWeek = markdownCountStartWeek,
                DefaultMarkdownType = defaultMarkdownType,
				DefaultDecisionState = defaultDecisionState,
                DefaultDecisionStateName = defaultDecisionState.ToString(),
                AllowPromoAsMarkdown = allowPromoAsMarkdown,
                MinimumPromoPercentage = minimumPromoPercentage,
                CreatedBy = userId
            };
        }
    }
}