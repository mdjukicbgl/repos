using System;
using System.Threading.Tasks;
using Markdown.Service;
using Markdown.WebApi.Auth;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Markdown.WebApi.Controllers
{
    [Route("api/hierarchy")]
    [Authorize(Policy = Policies.MKD_SCENARIO_VIEW)]
    public class HierarchyController : Controller
    {
        private readonly IHierarchyService _hierarchyService;

        public HierarchyController(IHierarchyService hierarchyService)
        {
            _hierarchyService = hierarchyService;
        }

        [HttpGet("")]
        public async Task<VmPage<VmHierarchy>> GetHierarchy(int? depth = null)
        {
            var result = await _hierarchyService.GetAll(depth);

            return new VmPage<VmHierarchy>
            {
                Items = VmHierarchy.Build(result),
                PageIndex = 1,
                PageSize = 1,
                TotalCount = result.Count
            };
        }

        [HttpGet("{id}/children")]
        public async Task<VmPage<VmHierarchy>> GetChildren(int id)
        {
            var result = await _hierarchyService.GetChildren(id);

            return new VmPage<VmHierarchy>
            {
                Items = VmHierarchy.Build(result),
                PageIndex = 1,
                PageSize = 1,
                TotalCount = result.Count
            };
        }
    }
}
