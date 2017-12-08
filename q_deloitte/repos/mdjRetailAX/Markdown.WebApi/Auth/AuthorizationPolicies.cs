﻿using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Markdown.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.DependencyInjection;

namespace Markdown.WebApi.Auth
{
	public static class AuthorizationPolicies
	{
		public static IServiceCollection AddAuthorizationPolicies(this IServiceCollection services, bool IsDevelopment)
		{
		
				services.AddAuthorization(options =>
					{
                        options.AddPolicy(Policies.MKD_DASHBOARD_VIEW,
									  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_DASHBOARD_VIEW)));
						options.AddPolicy(Policies.MKD_HOME_VIEW,
									  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_HOME_VIEW)));
						options.AddPolicy(Policies.MKD_SCENARIO_CREATE,
								  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_CREATE)));
						options.AddPolicy(Policies.MKD_SCENARIO_CALCULATE,
										  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_CALCULATE)));
						options.AddPolicy(Policies.MKD_SCENARIO_PUBLISH,
										  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_PUBLISH)));
						options.AddPolicy(Policies.MKD_SCENARIO_PREPARE,
										  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_PREPARE)));
						options.AddPolicy(Policies.MKD_SCENARIO_VIEW,
										  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_VIEW)));
						options.AddPolicy(Policies.MKD_SCENARIO_UPLOAD,
												  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_UPLOAD)));
                        options.AddPolicy(Policies.MKD_SCENARIO_UPLOAD_FILE,
												  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_UPLOAD_FILE)));
                        options.AddPolicy(Policies.MKD_RECOMMENDATION_ACCEPT,
										  policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_RECOMMENDATION_ACCEPT)));
						options.AddPolicy(Policies.MKD_RECOMMENDATION_REJECT,
												 policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_RECOMMENDATION_REJECT)));
						options.AddPolicy(Policies.MKD_RECOMMENDATION_REVISE,
												 policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_RECOMMENDATION_REVISE)));
						options.AddPolicy(Policies.MKD_RECOMMENDATION_VIEW,
														 policy => policy.Requirements.Add(new ServerAuthorizationRequirement(Policies.MKD_RECOMMENDATION_VIEW)));
                
					});

                services.AddScoped<IAuthorizationHandler, ServerAuthorizationHandler>();
			
			return services;
		}

	}

	public class DummyAuthorizationRequirement : IAuthorizationRequirement
	{
		public DummyAuthorizationRequirement() { }
	}

	public class DummyAuthorizationHandler : AuthorizationHandler<DummyAuthorizationRequirement>
	{
		protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, DummyAuthorizationRequirement requirement)
		{
			context.Succeed(requirement);
			return Task.CompletedTask;
		}
	}

}