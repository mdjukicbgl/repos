using Markdown.WebApi.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Markdown.WebApi.Controllers
{
    [Authorize(Policy = Policies.MKD_HOME_VIEW)]
    public class HomeController : Controller
    {
        public void Index()
        {
            Response.Redirect("/swagger", true);
        }
    }
}
