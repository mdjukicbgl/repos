using System.Threading;
using System.Threading.Tasks;
using Amazon;
using Amazon.Lambda;
using Amazon.Lambda.Model;
using Amazon.Runtime;
using Markdown.Common.Settings;
using Newtonsoft.Json;

namespace Markdown.Common.Clients
{
    public class MarkdownAwsSdkClient : IMarkdownClient
    {
        private readonly IAmazonLambda _client;
        private readonly string _functionName;

        private class ModelPayload
        {
            public string Program { get; } = "model";
            public int ModelId { get; set; }
        }

        private class PreparePayload
        {
            public string Program { get; } = "partition";
            public int ModelId { get; set; }
            public int ModelRunId { get; set; }
            public int ScenarioId { get; set; }
            public int OrganisationId { get; set; }
            public int UserId { get; set; }
            public int PartitionCount { get; set; }
            public bool Calculate { get; set; }
            public bool Upload { get; set; }
        }

        private class CalculatePayload
        {
            public string Program { get; } = "calc";
            public int ModelId { get; set; }
            public int ModelRunId { get; set; }
            public int ScenarioId { get; set; }
			public int OrganisationId { get; set; }
            public int UserId { get; set; }
            public int PartitionId { get; set; }
            public int PartitionCount { get; set; }
            public bool Upload { get; set; }
        }

        private class UploadPayload
        {
            public string Program { get; } = "upload";
            public int ScenarioId { get; set; }
            public int OrganisationId { get; set; }
            public int UserId { get; set; }
            public int PartitionId { get; set; }
            public int PartitionCount { get; set; }
        }

        public MarkdownAwsSdkClient(IAmazonLambda client, string functionName)
        {
            _client = client;
            _functionName = functionName;
        }

        public async Task<int> ModelBuild(int modelId, CancellationToken cancellationToken = default(CancellationToken))
        {
            var payload = new ModelPayload
            {
                ModelId = modelId
            };

            await _client.InvokeAsync(new InvokeRequest
            {
                FunctionName = _functionName,
                InvocationType = "Event",
                Payload = JsonConvert.SerializeObject(payload)
            }, cancellationToken);

            return modelId;
        }

        public async Task<int> ScenarioPrepare(int modelId, int modelRunId, int scenarioId,int organisationId,int userId, int partitionCount, bool calculate = false, bool upload = false, CancellationToken cancellationToken = default(CancellationToken))
        {
            var payload = new PreparePayload
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionCount = partitionCount,
                Calculate = calculate,
                Upload = upload
            };

            await _client.InvokeAsync(new InvokeRequest
            {
                FunctionName = _functionName,
                InvocationType = "Event",
                Payload = JsonConvert.SerializeObject(payload)
            }, cancellationToken);

            return modelId;
        }

        public async Task ScenarioCalculate(int modelId, int modelRunId, int scenarioId,int organisationId,int userId, int partitionId, int partitionCount, bool upload = false, CancellationToken cancellationToken = default(CancellationToken))
        {
            var payload = new CalculatePayload
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
				UserId = userId,
                PartitionId = partitionId,
                PartitionCount = partitionCount,
                Upload = upload
            };

            await _client.InvokeAsync(new InvokeRequest
            {
                FunctionName = _functionName,
                InvocationType = "Event",
                Payload = JsonConvert.SerializeObject(payload)
            }, cancellationToken);
        }

        public async Task ScenarioUpload(int scenarioId,int organisationId,int userId, int partitionId, int partitionCount, CancellationToken cancellationToken = default(CancellationToken))
        {
            var payload = new UploadPayload
            {
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
				UserId = userId,
                PartitionId = partitionId,
                PartitionCount = partitionCount
            };

            await _client.InvokeAsync(new InvokeRequest
            {
                FunctionName = _functionName,
                InvocationType = "Event",
                Payload = JsonConvert.SerializeObject(payload)
            }, cancellationToken);
        }
    }
}