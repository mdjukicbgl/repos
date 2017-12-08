using System.Net;
using System.Threading.Tasks;
using Markdown.Service;
using Markdown.WebApi.Auth;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Markdown.WebApi.Controllers
{
    [Route("api/priceladder")]
    [Authorize(Policy = Policies.MKD_RECOMMENDATION_VIEW)]
    public class PriceLadderController : Controller
    {
        private readonly IPriceLadderService _priceLadderService;

        public PriceLadderController(IPriceLadderService priceLadderService)
        {
            _priceLadderService = priceLadderService;
        }

        [HttpGet("{priceLadderId}")]
        public async Task<VmPriceLadder> Get(int priceLadderId)
        {
            if (priceLadderId <= 0)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);

            var result = await _priceLadderService.GetById(priceLadderId);
            if (result == null)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.NotFound);

            return VmPriceLadder.Build(result);
        }
    }
}
