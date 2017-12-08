
using Markdown.Service;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Markdown.WebApi.Auth;

namespace Markdown.WebApi.Controllers
{
    [Route("api/dashboard")]
    [Authorize(Policy = Policies.MKD_DASHBOARD_VIEW)]
    public class DashboardController : Controller
    {
        private readonly IDashboardWebService _dashboardWebService;

        public DashboardController(IDashboardWebService dashboardWebService)
        {
            _dashboardWebService = dashboardWebService;
        }

        [HttpGet("")]
        public async Task<VmPage<VmDashboard>> Get()
        {
            var model = await _dashboardWebService.Get();

            return new VmPage<VmDashboard>
            {
                Items = new List<VmDashboard> { VmDashboard.Build(model) },
                PageIndex = 1,
                PageSize = 1,
                TotalCount = 1
            };
        }
    }
}
