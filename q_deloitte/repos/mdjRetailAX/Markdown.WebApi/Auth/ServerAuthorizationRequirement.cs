using System;
using System.Linq;
using System.Security.Claims;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Markdown.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Logging;
using Serilog;

namespace Markdown.WebApi.Auth
{
	public class ServerAuthorizationRequirement : IAuthorizationRequirement
	{
		public string AccessRequired { get; private set; }

		public ServerAuthorizationRequirement(string accessRequired)
		{
			AccessRequired = accessRequired;
		}
	}

	public class ServerAuthorizationHandler : AuthorizationHandler<ServerAuthorizationRequirement>
	{
		private readonly Microsoft.Extensions.Logging.ILogger _logger;
        private readonly IAccessControlService _accessControlService;


		public ServerAuthorizationHandler(ILoggerFactory loggerFactory, IAccessControlService accessControlService )
		{
			_logger = loggerFactory.CreateLogger(this.GetType().FullName);
            _accessControlService = accessControlService;
		}

		protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, ServerAuthorizationRequirement requirement)
		{
            if (!context.User.HasClaim(c => c.Type == ClaimTypes.Email))
			{
				return Task.CompletedTask;
			}

			var emailAddress = context.User.FindFirst(
				c => c.Type == ClaimTypes.Email).Value;

			var regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
			var match = regex.Match(emailAddress);

			if (match.Success)
			{
				_logger.LogInformation("Email Address of JWT payload:" + emailAddress);

                var vmOrgData = _accessControlService.GetAll(emailAddress);

                //Compare AccessRequired to user permissions from db.
                if (vmOrgData.Permissions.Exists(p => p.PermissionCode.Equals(requirement.AccessRequired)))
                {
                    if (context.Resource is Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext mvcContext)
                    {
                        mvcContext.HttpContext.Items[AuthKeys.OrganisationKey] = vmOrgData.OrganisationId;
                        mvcContext.HttpContext.Items[AuthKeys.ScenarioIdsKey] = vmOrgData.ScenarioIds;
                        mvcContext.HttpContext.Items[AuthKeys.UserKey] = vmOrgData.UserId;
                        context.Succeed(requirement);
                    }
                }
			}

			return Task.CompletedTask;
		}
	}
}
