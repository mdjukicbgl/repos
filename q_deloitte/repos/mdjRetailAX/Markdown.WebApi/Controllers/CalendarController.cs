using System.Net;
using System.Threading.Tasks;
using Markdown.Service;
using Markdown.WebApi.Auth;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HttpStatusCodeException = Markdown.WebApi.ErrorHandlerMiddleware.HttpStatusCodeException;

namespace Markdown.WebApi.Controllers
{
    [Route("api/calendar")]
    [Authorize(Policy = Policies.MKD_SCENARIO_CREATE)]
    public class CalendarController : Controller
    {
        private readonly ICalendarWebService _calendarWebService;

        public CalendarController(ICalendarWebService calendarWebService)
        {
            _calendarWebService = calendarWebService;
        }

        [HttpGet("{startDate}/{numberWeeks}")]
        public async Task<VmCalendar> Get(long? startDate, int? numberWeeks)
        {
            if (!startDate.HasValue)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            
            if (!numberWeeks.HasValue)
                numberWeeks = 8; //TODO: Where should this default go.

            var results = await _calendarWebService.Get(startDate.Value, numberWeeks.Value);

            return VmCalendar.Build(results);
        }
    }
}
