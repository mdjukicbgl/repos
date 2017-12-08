using System;
using System.Collections.Generic;

namespace Markdown.Service.Models
{
    public class SmCalendar
    {
        
        public int CalendarId { get; set; }
        public string CalendarName { get; set; }
        public long StartDate { get; set; }
        public int NumberWeeks { get; set; }
        public List<SmWeek> Weeks { get; set; }
    
    }
}