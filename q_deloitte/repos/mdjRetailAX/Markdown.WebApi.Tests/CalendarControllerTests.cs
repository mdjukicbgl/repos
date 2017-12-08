using System;
using System.Net;
using Markdown.Service;
using Markdown.WebApi;
using Markdown.WebApi.Controllers;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace Markdown.WebApi.Tests
{
    public class CalendarControllerTests
    {

		private readonly Mock<ICalendarWebService> _calendarServiceMock;

        public CalendarControllerTests()
        {
            _calendarServiceMock = new Mock<ICalendarWebService>();
        }

        [Fact]
		public void Get_ThrowsBadRequest_IfNoStartDateSupplied()
		{
            var calendarController = new CalendarController(_calendarServiceMock.Object);
            var response= calendarController.Get(null, null);
            var httpStatusCodeException = (ErrorHandlerMiddleware.HttpStatusCodeException)response.Exception.InnerException;
            Assert.Equal(HttpStatusCode.BadRequest,httpStatusCodeException.StatusCode);
		}

        [Fact]
		public void Get_DefaultsNumberOfWeeks_IfNotSupplied()
		{
            _calendarServiceMock.Setup(mock => mock.Get(123, 8));
            var calendarController = new CalendarController(_calendarServiceMock.Object);
            var response= calendarController.Get(123, null);
            _calendarServiceMock.Verify(mock => mock.Get(123, 8), Times.Once());
		}
    }
}
