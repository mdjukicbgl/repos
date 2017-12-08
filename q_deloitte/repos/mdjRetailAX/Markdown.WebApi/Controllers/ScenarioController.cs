﻿﻿﻿﻿using System;
using System.Net;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;

using Markdown.Service;
using Markdown.WebApi.Models;

using HttpStatusCodeException = Markdown.WebApi.ErrorHandlerMiddleware.HttpStatusCodeException;
using Microsoft.AspNetCore.Authorization;
using Markdown.WebApi.Auth;
using RetailAnalytics.Data;

namespace Markdown.WebApi.Controllers
{
    [Route("api/scenario")]
	[Authorize(Policy = Policies.MKD_SCENARIO_VIEW)]
    public class ScenarioController : Controller
    {
        private readonly IHierarchyService _hierarchyService;
        private readonly IScenarioWebService _scenarioWebService;
        private readonly IRecommendationProductService _recommendationProductService;
        private readonly IFileUploadService _fileUploadService;
        private readonly IOrganisationDataProvider _organisationDataProvider;

        public ScenarioController(IHierarchyService hierarchyService,
                                  IScenarioWebService scenarioWebService,
                                  IRecommendationProductService recommendationProductService, 
                                  IFileUploadService fileUploadService,
                                  IOrganisationDataProvider organisationDataProvider)
        {
            _hierarchyService = hierarchyService;
            _scenarioWebService = scenarioWebService;
            _recommendationProductService = recommendationProductService;
            _fileUploadService = fileUploadService;
            _organisationDataProvider = organisationDataProvider;
        }

        [HttpPost("")]
        [Authorize(Policy = Policies.MKD_SCENARIO_CREATE)]
        public async Task<int> Create(VmScenarioCreate model)
        {
            if (model == null)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);

            var productIds = new List<int>();
            
            // should we move that logic into the service layer or do we keep it in the view?
            if (model.UploadedFile != null)
            {
                var products = await _fileUploadService.GetContentsByGuid(model.UploadedFile.Value);
                productIds = products.Select(x => x.ProductId).ToList();
            }

            if (model.HierarchyIds.Count + productIds.Count == 0)
            {
                throw new Exception("No product in scope for scenario");
            }

            var scenarioId = await _scenarioWebService.Create(model.ScenarioName, model.Week, model.ScheduleMask, 
                                                              model.ScheduleWeekMin, model.ScheduleWeekMax, 
                                                              model.MarkdownCountStartWeek, model.DefaultMarkdownType, 
                                                              model.DefaultDecisionState,
                                                              model.AllowPromoAsMarkdown, model.MinimumPromoPercentage,
                                                              _organisationDataProvider.OrganisationId.Value ,
                                                              _organisationDataProvider.UserId.Value,
                                                              productIds, model.HierarchyIds);
            if (model.UploadedFile != null)
            {
                await _fileUploadService.useForScenario(model.UploadedFile.Value, scenarioId);
            }
            return scenarioId;
        }

        [HttpGet("")]
        public async Task<VmPage<VmScenarioSummary>> GetAll([FromQuery]ScenarioSummaryApiParams scenarioSummaryParams)
        {
			if (!ModelState.IsValid)
			{
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, ModelState.Errors());
			}

            var validFilters = scenarioSummaryParams.GetValidFilters();

            var sorts = scenarioSummaryParams.GetSorts();

            var results = await _scenarioWebService.GetAll(
                                                                validFilters,
                                                                sorts,
                                                                scenarioSummaryParams.PageIndex,
                                                                scenarioSummaryParams.PageLimit
                                                            );

            return new VmPage<VmScenarioSummary>
            {
                Items = VmScenarioSummary.Build(results),
                PageIndex = results.PageIndex,
                PageSize = results.PageSize,
                TotalCount = results.Total
            };
        }

        [HttpGet("{scenarioId}")]
        public async Task<VmScenarioSummary> Get(int scenarioId, int clientId=0)
        {
			if (scenarioId <= 0)
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}
            
			var result = await _scenarioWebService.Get(clientId, scenarioId);
            return VmScenarioSummary.Build(result);
        }

        [HttpGet("{scenarioId}/recommendations")]
        [Authorize(Policy = Policies.MKD_RECOMMENDATION_VIEW)]
        public async Task<VmPage<VmRecommendation>> GetRecommendations(int scenarioId,
                                                                       [FromQuery] RecommendationsApiParams recommendationsParams
                                                                        )
        {
			if (!ModelState.IsValid)
			{
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest,ModelState.Errors());
			}
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

			var validFilters = recommendationsParams.GetValidFilters();

			var sorts = recommendationsParams.GetSorts();
  
            var results = await _recommendationProductService.GetRecommendations(
                                                                            scenarioId,
															                recommendationsParams.PageIndex,
															                recommendationsParams.PageLimit,
                                                                            validFilters,
                                                                            sorts
                                                                           );

            return new VmPage<VmRecommendation>
            {
                Items = VmRecommendation.Build(results),
                PageIndex = results.PageIndex,
                PageSize = results.PageSize,
                TotalCount = results.Total
            };
        }

        [HttpPost("{scenarioId}/recommendation/{recommendationGuid}/accept")]
        [Authorize(Policy = Policies.MKD_RECOMMENDATION_ACCEPT)]
        public async Task<VmRecommendation> AcceptRecommendation(int scenarioId, Guid recommendationGuid)
        {
            if(!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
            {
                throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
            }

            var results = await _recommendationProductService.Accept(_organisationDataProvider.OrganisationId.Value,scenarioId,recommendationGuid);

            return VmRecommendation.Build(results);
        }

        [HttpPost("{scenarioId}/recommendation/{recommendationGuid}/reject")]
        [Authorize(Policy = Policies.MKD_RECOMMENDATION_REJECT)]
        public async Task<VmRecommendation> RejectRecommendation(int scenarioId, Guid recommendationGuid)
        {
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

            var results = await _recommendationProductService.Reject(_organisationDataProvider.OrganisationId.Value,scenarioId,recommendationGuid);

            return VmRecommendation.Build(results);
        }

		[HttpPost("{scenarioId}/recommendation/accept")]
		[Authorize(Policy = Policies.MKD_RECOMMENDATION_ACCEPT)]
		public async Task<int> AcceptAllRecommendations(int scenarioId)
		{
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

            return await _recommendationProductService.AcceptAll(_organisationDataProvider.OrganisationId.Value,scenarioId);
		}

		[HttpPost("{scenarioId}/recommendation/reject")]
		[Authorize(Policy = Policies.MKD_RECOMMENDATION_REJECT)]
		public async Task<int> RejectAllRecommendations(int scenarioId)
		{
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

			return await _recommendationProductService.RejectAll(_organisationDataProvider.OrganisationId.Value,scenarioId);
		}

		[HttpGet("{scenarioId}/totals")]
		public async Task<VmScenarioTotals> ScenarioTotals(int scenarioId)
		{
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

            var results =  await _scenarioWebService.GetScenarioTotals(scenarioId);

            return VmScenarioTotals.Build(results);
		}

		[HttpGet("{scenarioId}/recommendations/multiselect")]
		[Authorize(Policy = Policies.MKD_RECOMMENDATION_VIEW)]
		public async Task<List<string>> GetMultiSelectValues(int scenarioId,
																	  [FromQuery] RecommendationsApiParams recommendationsParams
																	   )
		{
			if (!ModelState.IsValid)
			{
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, ModelState.Errors());
			}
			if (!_organisationDataProvider.ScenarioIds.Contains(scenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

			var multiSelectField = recommendationsParams.GetMultiSelectField();

            var results = await _recommendationProductService.GetMultiSelectValues(
																			scenarioId,
																			multiSelectField
																		   );

            return results;
		}
    }
}

