using System;
using System.Collections.Generic;
using Markdown.Common.Enums;

namespace Markdown.WebApi.Models
{
    public class VmScenarioCreate
    {
        public  VmScenarioCreate()
        {
            // TODO remove default values
            Week = 897;
            ScheduleMask = 255;
            ScheduleWeekMin = 890;
            ScheduleWeekMax = 897;
            ScenarioName = "Unnamed scenario";
            MarkdownCountStartWeek = 800;
            DefaultMarkdownType = 255;
            DefaultDecisionState = DecisionState.Neutral;
            AllowPromoAsMarkdown = true;
            MinimumPromoPercentage = 0;
        }

        public string ScenarioName { get; set; }
        public int Week { get; set; }
        public int ScheduleMask { get; set; }
        public int ScheduleWeekMin { get; set; }
        public int ScheduleWeekMax { get; set; }
        public int MarkdownCountStartWeek { get; set; }
        public int DefaultMarkdownType { get; set; }
        public DecisionState DefaultDecisionState { get; set; }
        public bool AllowPromoAsMarkdown { get; set; }
        public decimal MinimumPromoPercentage { get; set; }
        public List<int> HierarchyIds { get; set; } = new List<int>();
        public Guid? UploadedFile { get; set; }
    }
}
