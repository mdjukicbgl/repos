using System;
using System.Collections.Generic;
using System.Linq;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmScenario
    {
        protected VmScenario()
        {
        }

        public int ScenarioId { get; set; }
        public int? Week { get; set; }
        public int ScheduleWeekMin { get; set; }
        public int ScheduleWeekMax { get; set; }
        public int ScheduleStageMin { get; set; }
        public int ScheduleStageMax { get; set; }
        public int? StageMax { get; set; }
        public int? StageOffsetMax { get; set; }
        public decimal? PriceFloor { get; set; }
        public int CustomerId { get; set; }
        public string ScenarioName { get; set; }
        public int ScheduleMask { get; set; } = 255;
        public int MarkdownCountStartWeek { get; set; } = 800;
        public int DefaultMarkdownType { get; set; } = 255;
        public bool AllowPromoAsMarkdown { get; set; }
        public decimal MinimumPromoPercentage { get; set; }

        public static VmScenario Build(SmScenario entity)
        {
            return new VmScenario
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
                CustomerId = entity.OrganisationId,
                ScenarioName = entity.ScenarioName,
                ScheduleMask = entity.ScheduleMask,
                MarkdownCountStartWeek = entity.MarkdownCountStartWeek,
                DefaultMarkdownType = entity.DefaultMarkdownType,
                AllowPromoAsMarkdown = entity.AllowPromoAsMarkdown,
                MinimumPromoPercentage = entity.MinimumPromoPercentage
            };
        }

        public static List<VmScenario> Build(List<SmScenario> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}
