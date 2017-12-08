using System;
using System.Collections.Generic;
using System.Linq;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmWeek
    {
        public int WeekNumber { get; set; }
        public long WeekStart { get; set; }
        public int DayWeekStart { get; set; }

        public static VmWeek Build(SmWeek model)
        {
            return new VmWeek
            {
                WeekNumber = model.WeekNumber,
                WeekStart = model.WeekStart,
                DayWeekStart = model.DayWeekStart
            };
        }

        public static List<VmWeek> Build(List<SmWeek> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}