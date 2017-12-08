using System.Collections.Generic;
using System.Threading.Tasks;
using Markdown.Service.Models;
using System;
using System.Globalization;

namespace Markdown.Service
{
    public interface ICalendarWebService
    {
        Task<SmCalendar> Get(long startDate, int numberWeeks);
    }

    public class CalendarWebService : ICalendarWebService
    {

        public CalendarWebService()
        {

        }

        public async Task<SmCalendar> Get(long startDate, int numberWeeks)
        {
            return await GetStub(startDate, numberWeeks);
        }

        private async Task<SmCalendar> GetStub(long startDate, int numberWeeks)
        {
            var weeks = new List<SmWeek>();
            System.DateTime dateTime = new System.DateTime(1970, 1, 1, 0, 0, 0, 0);
            var weekStartDate = dateTime.AddSeconds( startDate);
            for (int a = 0; a < numberWeeks; a = a + 1)
            {
                weekStartDate = DateTimeExtensions.StartOfWeek(weekStartDate.AddDays(7), DayOfWeek.Monday);
                weeks.Add(new SmWeek{
                    WeekNumber = DateTimeExtensions.GetWeekNumber(weekStartDate),
                    WeekStart = (long)weekStartDate.ToUniversalTime().Subtract(
                                new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                                ).TotalSeconds,
                    DayWeekStart = 1
                });
                weekStartDate.AddDays(7);
            }

            return await Task.FromResult(new SmCalendar
            {
                CalendarId = 1,
                CalendarName = "Test Calendar",
                StartDate = startDate,
                NumberWeeks = numberWeeks,
                Weeks = weeks
            });
        }
    }

    public static class DateTimeExtensions
    {
        public static DateTime StartOfWeek(this DateTime dt, DayOfWeek startOfWeek)
        {
            int diff = dt.DayOfWeek - startOfWeek;
            if (diff < 0)
            {
                diff += 7;
            }
            return dt.AddDays(-1 * diff).Date;
        }

        public static int GetWeekNumber(DateTime date)
        {
            CultureInfo ciCurr = CultureInfo.CurrentCulture;
            int weekNum = ciCurr.Calendar.GetWeekOfYear(date, CalendarWeekRule.FirstFourDayWeek, DayOfWeek.Monday);
            return weekNum;
        }

    }
}
