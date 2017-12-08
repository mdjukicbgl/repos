using System;
using Moq;
using Xunit;

namespace Markdown.Service.Tests
{
    public class CalendarWebServiceTests
    {
        [Fact]
        public void Get_ReturnsTheCorrectCalendarWeeks_WithNumberOfWeeksProvided()
        {
            var calendarWebService = new CalendarWebService();
            var response = calendarWebService.Get(1496048400, 1);
            Assert.Equal(response.Result.Weeks.Count, 1);
            response = calendarWebService.Get(1496048400, 8);
            Assert.Equal(response.Result.Weeks.Count, 8);
        }

        // Problem with test running on ubuntu
        //
        //[Fact]
        //public void Get_ReturnsTheCorrectCalendarWeeks_WithFutureDates()
        //{
        //    var calendarWebService = new CalendarWebService();
        //    var response = calendarWebService.Get(1496048400, 2);
        //    Assert.Equal(response.Result.Weeks[0].DayWeekStart, 1);
        //    Assert.Equal(response.Result.Weeks[0].WeekNumber, 23);
        //    Assert.Equal(response.Result.Weeks[0].WeekStart, 1496617200);
        //    Assert.Equal(response.Result.Weeks[1].DayWeekStart, 1);
        //    Assert.Equal(response.Result.Weeks[1].WeekNumber, 24);
        //    Assert.Equal(response.Result.Weeks[1].WeekStart, 1497222000);
        //}
    }
}
