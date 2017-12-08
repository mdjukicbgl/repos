using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

using Markdown.Common.Clients;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Authorization;
using Markdown.WebApi.Auth;
using RetailAnalytics.Data;
using static Markdown.WebApi.ErrorHandlerMiddleware;

namespace Markdown.WebApi.Controllers
{
    [Route("api/control")]
    [Authorize(Policy = Policies.MKD_SCENARIO_PREPARE)]
    public class ControlController : Controller
    {
        private readonly IMarkdownClient _client;
		private readonly IOrganisationDataProvider _organisationDataProvider;

        public ControlController(IMarkdownClient client, IOrganisationDataProvider organisationDataProvider)
        {
            _client = client;
            _organisationDataProvider = organisationDataProvider;
        }

        [HttpPost("model/build")]
        public async Task<int> ModelBuild(VmControlModel model)
        {
            if (model.ModelId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);

            return await _client.ModelBuild(model.ModelId);
        }

        [HttpPost("scenario/prepare")]
		[Authorize(Policy = Policies.MKD_SCENARIO_PREPARE)]
        public async Task<int> Prepare(VmControlPrepare model)
        {
            if (model.ModelId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.ModelRunId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.ScenarioId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.PartitionCount <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);

            if (!_organisationDataProvider.ScenarioIds.Contains(model.ScenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

            return await _client.ScenarioPrepare(model.ModelId, model.ModelRunId, model.ScenarioId,
                                                 _organisationDataProvider.OrganisationId.Value,
                                                 _organisationDataProvider.UserId.Value,
                                                 model.PartitionCount, 
                                                 model.Calculate, model.Upload);
        }

        [HttpPost("scenario/calculate")]
        [Authorize(Policy = Policies.MKD_SCENARIO_CALCULATE)]
        public async Task Calculate(VmControlCalculate model)
        {
            if (model.ModelId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.ModelRunId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.ScenarioId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.PartitionId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.PartitionCount <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);

			if (!_organisationDataProvider.ScenarioIds.Contains(model.ScenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

            await _client.ScenarioCalculate(model.ModelId, model.ModelRunId, model.ScenarioId,
                                            _organisationDataProvider.OrganisationId.Value,
											 _organisationDataProvider.UserId.Value,
                                            model.PartitionId, 
                                            model.PartitionCount, model.Upload);
        }

        [HttpPost("scenario/upload")]
        [Authorize(Policy = Policies.MKD_SCENARIO_UPLOAD)]
        public async Task Upload(VmControlUpload model)
        {
            if (model.ScenarioId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.PartitionId <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);
            if (model.PartitionCount <= 0)
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest);

			if (!_organisationDataProvider.ScenarioIds.Contains(model.ScenarioId))
			{
				throw new HttpStatusCodeException(HttpStatusCode.Unauthorized);
			}

            await _client.ScenarioUpload(model.ScenarioId,
                                         _organisationDataProvider.OrganisationId.Value,
										   _organisationDataProvider.UserId.Value,
                                         model.PartitionId, model.PartitionCount);
        }
    }
}
