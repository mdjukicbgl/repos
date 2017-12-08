using System;
using System.Net;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

using Serilog;

using Markdown.Common.Settings;

using Markdown.Service;
using Markdown.Service.Models;

using Markdown.WebApi.Auth;
using Markdown.WebApi.Models;

using HttpStatusCodeException = Markdown.WebApi.ErrorHandlerMiddleware.HttpStatusCodeException;
using RetailAnalytics.Data;

namespace Markdown.WebApi.Controllers
{
	[Route("api/recommendation")]
	[Authorize(Policy = Policies.MKD_RECOMMENDATION_VIEW)]
	public class RecommendationController : Controller
	{
		private readonly ILogger _logger;
		private readonly IMarkdownService _markdownService;
		private readonly IScenarioService _scenarioService;
		private readonly IScenarioWebService _scenarioWebService;
		private readonly IScenarioResultService _scenarioResultsService;

		private readonly IRecommendationProductService _recommendationProductService;
        private readonly IOrganisationDataProvider _organisationDataProvider;

		public RecommendationController(
			ILogger logger,
			IMarkdownService markdownService,
			IScenarioService scenarioService,
			IScenarioWebService scenarioWebService,
			IScenarioResultService scenarioResultsService,
			IRecommendationProductService recommendationProductService,
            IOrganisationDataProvider organisationDataProvider)
		{
			_logger = logger;
			_markdownService = markdownService;
			_scenarioService = scenarioService;
			_scenarioWebService = scenarioWebService;
			_scenarioResultsService = scenarioResultsService;
			_recommendationProductService = recommendationProductService;
            _organisationDataProvider = organisationDataProvider;
		}

		[HttpPost("{guid}/revise")]
		[Authorize(Policy = Policies.MKD_RECOMMENDATION_REVISE)]
		public async Task<VmRecommendation> Revise(Guid guid, [FromBody]VmScenarioRevisionCreate model)
		{
			// TODO add client id
			var clientId = 0;

			if (guid == Guid.Empty)
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "Empty recommendationGuid supplied");

			if (model == null)
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "Missing model");

			if (model.Revisions == null || !model.Revisions.Any())
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "No revisions supplied");

			var revisions = model.Revisions.OrderBy(x => x.Week).ToList();

			var product = await _recommendationProductService.GetRecommendationByGuid(0, guid);

			if (product == null)
				throw new HttpStatusCodeException(HttpStatusCode.NotFound, $"Recommendation not found for guid ${guid}");

			if (!_organisationDataProvider.ScenarioIds.Contains(product.ScenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

			if ((decimal)revisions.First().Discount < product.CurrentMarkdownDepth)
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "First discount lower than current markdown depth");

			return await Revise(clientId, product, revisions);
		}

		private async Task<VmRecommendation> Revise(int clientId, SmRecommendationProductSummary product, List<VmScenarioRevision> revisions)
		{
			var constraints = revisions
				.Take(1)
				.Concat(revisions.Zip(revisions.Skip(1), (first, second) => second.Week > first.Week && second.Discount > first.Discount ? second : null))
				.Where(x => x != null)
				.Select(x => SmWeekConstraint.Fixed(x.Week, (decimal)x.Discount))
				.ToList();

			if (!constraints.Any())
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "No markdowns in the revision model data");

			var scenarioSummary = await _scenarioWebService.Get(clientId, product.ScenarioId);
			if (scenarioSummary == null)
				throw new HttpStatusCodeException(HttpStatusCode.InternalServerError,
					$"Missing scenario for client id ${product.ClientId} with scenario id ${product.ScenarioId}");

			var weeks = Enumerable.Range(scenarioSummary.Scenario.ScheduleWeekMin, scenarioSummary.Scenario.ScheduleWeekMax - scenarioSummary.Scenario.ScheduleWeekMin + 1).ToList();
			if (constraints.Select(x => x.Week).Except(weeks).Any())
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "All revision weeks must be within [ScheduleWeekMin..ScheduleWeekMax]");

			var settings = MarkdownFunctionSettings.FromWebApiConfiguration(product.ModelId, 100,
                                                                            product.ScenarioId,_organisationDataProvider.OrganisationId.Value,
                                                                            _organisationDataProvider.UserId.Value, product.PartitionNumber,
				            product.PartitionCount);

			var modelData = await _scenarioService.GetModelData(settings);
			var scenarioData = await _scenarioService.GetScenarioData(settings, settings.PartitionId);

			var productData = scenarioData.Item2.FirstOrDefault(x => x.ProductId == product.ProductId);
			if (productData == null)
				throw new HttpStatusCodeException(HttpStatusCode.InternalServerError, "Missing original product by id " + product.ProductId);

			var revisionValues = revisions.Select(x => (decimal)x.Discount).ToList();

			var constraintValues = constraints
				.Select(x => x.Min)
				.Concat(constraints.Select(x => x.Max))
				.Distinct()
				.Where(x => x != null)
				.Select(x => (decimal)x)
				.ToList();
			if (constraintValues.Except(productData.PriceLadder.Values).Any())
				throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "All revision discounts must be price ladder values");

			var modelId = product.ModelId;

			var revisionId = product.RevisionCount + 1;

			// Caculate the mask passed in
			var revisionMask = weeks
				.Select((x, i) => new { Week = x, Index = i })
				.Where(item => constraints.Any(x => x.Week == item.Week))
				.Aggregate(0, (current, item) => current | 1 << item.Index);

			var schedules = new List<SmDenseSchedule>
			{
				SmDenseSchedule.FromInteger(revisionMask, weeks.First(), weeks.Count, constraints)
			};

			// Calculate
			var result = _markdownService.Calculate(scenarioSummary.Scenario, modelId, revisionId, schedules,
				modelData.DecayHierarchies, modelData.ElasticityHierarchies, productData, revisionValues);

			// Upload
            await _scenarioResultsService.Upload(settings, product, revisionId, result.Recommendations, _organisationDataProvider.UserId.Value);

			// Update state and retrieve
			var finalResult = await _recommendationProductService.Revise(

				clientId: product.ClientId,
				scenarioId: product.ScenarioId,
				productId: product.ProductId);

			return VmRecommendation.Build(finalResult);
		}
	}
}