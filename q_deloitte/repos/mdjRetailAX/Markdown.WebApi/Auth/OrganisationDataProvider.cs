﻿using System;
using System.Collections.Generic;
using Markdown.WebApi.Auth;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using RetailAnalytics.Data;
using SimpleInjector;

namespace Markdown.WebApi.Auth
{
    public class OrganisationDataProvider : IOrganisationDataProvider
    {
		private readonly IHttpContextAccessor _httpContextAccessor;

        public OrganisationDataProvider(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public int? OrganisationId
        { 
            get
            {
                if (_httpContextAccessor.HttpContext != null && _httpContextAccessor.HttpContext.Items != null)
                {
                    int? organisationId = _httpContextAccessor.HttpContext.Items[AuthKeys.OrganisationKey] as int?;

                    if (organisationId.HasValue)
                    {
                        return organisationId.Value;
                    }
                }

                return null;
            }
        }

        public List<int> ScenarioIds
        {
			get
			{
				if (_httpContextAccessor.HttpContext != null && _httpContextAccessor.HttpContext.Items != null)
				{
					List<int> scenarioIds = _httpContextAccessor.HttpContext.Items[AuthKeys.ScenarioIdsKey] as List<int>;

                    if (scenarioIds!=null)
					{
						return scenarioIds;
					}
				}

                return new List<int>();
			}
        }

        public int? UserId 
        {
			get
			{
				if (_httpContextAccessor.HttpContext != null && _httpContextAccessor.HttpContext.Items != null)
				{
                    int? userId = _httpContextAccessor.HttpContext.Items[AuthKeys.UserKey] as int?;

					if (userId.HasValue)
					{
						return userId.Value;
					}
				}

				return null;
			}
        }
    }

    public static class OrganisationIfProviderFactory 
    {
		public static IServiceCollection AddOrganisationDataProvider(this IServiceCollection services, bool IsDevelopment)
		{
             services.AddScoped<IOrganisationDataProvider, OrganisationDataProvider>();

			return services;
		}

        public static Container RegisterOrganisationDataProvider(this Container configRoot, bool IsDevelopment)
        {
            configRoot.Register<IOrganisationDataProvider, OrganisationDataProvider>(Lifestyle.Scoped);

            return configRoot;
        }      
    }

	public class MockOrganisationDataProvider : IOrganisationDataProvider
	{
		public int? OrganisationId
		{
			get { return 1; }
		}


		public List<int> ScenarioIds
		{
			get
			{
				return new List<int>();
			}
		}

        public int? UserId
		{
			get { return 1; }
		}
    }
}
