using System;
using System.Collections.Generic;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmCalendar
    {
        
        public int CalendarId { get; set; }
        public string CalendarName { get; set; }
        public long StartDate { get; set; }
        public int NumberWeeks { get; set; }
        public List<VmWeek> Weeks { get; set; }

        public static VmCalendar Build(SmCalendar model)
        {
            return new VmCalendar
            {
                CalendarId = model.CalendarId,
                CalendarName = model.CalendarName,
                StartDate = model.StartDate,
                NumberWeeks = model.NumberWeeks,
                Weeks = VmWeek.Build(model.Weeks)
            };
        }

    
    }
}