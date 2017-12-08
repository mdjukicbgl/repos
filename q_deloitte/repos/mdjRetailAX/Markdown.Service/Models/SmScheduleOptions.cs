using System;
using System.Collections.Generic;

namespace Markdown.Service.Models
{
    public class SmScheduleOptions
    {
        public int WeekMin { get; set; }
        public int WeekMax { get; set; }
        public int WeeksAllowed { get; set; }
        public int WeeksRequired { get; set; }
        public int WeekCount => WeekMax - WeekMin +  1;
        public bool ExcludeConsecutiveWeeks { get; set; }
        public List<SmWeekConstraint> Constraints = new List<SmWeekConstraint>();
    }
}