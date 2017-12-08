using System;
using System.Text;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Markdown.Common.Clients
{
    public class MarkdownApiGatewayClient : IMarkdownClient
    {
        private string ApiKey { get; }
        private HttpClient Client { get; }

        private string BaseUrl { get; }
        private string BuildUrl => BaseUrl + "/model/build";
        private string PrepareUrl => BaseUrl + "/scenario/prepare";
        private string GenerateUrl => BaseUrl + "/scenario/calculate";
        private string UploadUrl => BaseUrl + "/scenario/upload";

        private struct ModelPayload
        {
            public int ModelId { get; set; }
        }

        private class PreparePayload
        {
            public int ModelId { get; set; }
            public int ModelRunId { get; set; }
            public int ScenarioId { get; set; }
			public int OrganisationId { get; set; }
            public int UserId { get; set; }
            public int PartitionCount { get; set; }
            public bool Calculate { get; set; }
            public bool Upload { get; set; }
        }

        private struct CalculatePayload
        {
            public int ModelId { get; set; }
            public int ModelRunId { get; set; }
            public int ScenarioId { get; set; }
            public int OrganisationId { get; set; }
            public int UserId { get; set; }
            public int PartitionId { get; set; }
            public int PartitionCount { get; set; }
            public bool Upload { get; set; }
        }

        private struct UploadPayload
        {
            public int ScenarioId { get; set; }
            public int OrganisationId { get; set; }
            public int UserId { get; set; }
            public int PartitionId { get; set; }
            public int PartitionCount { get; set; }
        }

        public MarkdownApiGatewayClient(string apiKey, string baseUrl)
        {
            ApiKey = apiKey;
            BaseUrl = baseUrl;
            Client = new HttpClient {Timeout = TimeSpan.FromMinutes(2)};
        }

        public async Task<int> ModelBuild(int modelId, CancellationToken cancellationToken = default(CancellationToken))
        {
            var message = GetRequestMessage(HttpMethod.Post, BuildUrl, new ModelPayload
            {
                ModelId = modelId
            });

            var response = await Client.SendAsync(message, cancellationToken);
            response.EnsureSuccessStatusCode();

            var result = await response.Content.ReadAsStringAsync();
            return int.Parse(result);
        }

        public async Task<int> ScenarioPrepare(int modelId, int modelRunId, int scenarioId,int organisationId,int userId, int partitionCount, bool calculate = false, bool upload = false, CancellationToken cancellationToken = default(CancellationToken))
        {
            var message = GetRequestMessage(HttpMethod.Post, PrepareUrl, new PreparePayload
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionCount = partitionCount,
                Calculate = calculate,
                Upload = upload
            });

            var response = await Client.SendAsync(message, cancellationToken);
            response.EnsureSuccessStatusCode();

            return scenarioId;
        }

        public async Task ScenarioCalculate(int modelId, int modelRunId, int scenarioId,int organisationId,int userId, int partitionId, int partitionCount, bool upload = false, CancellationToken cancellationToken = default(CancellationToken))
        {
            var message = GetRequestMessage(HttpMethod.Post, GenerateUrl, new CalculatePayload
            {
                ModelId = modelId,
                ModelRunId = modelRunId,
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionId = partitionId,
                PartitionCount = partitionCount,
                Upload = upload
            });

            var response = await Client.SendAsync(message, cancellationToken);
            response.EnsureSuccessStatusCode();
        }

        public async Task ScenarioUpload(int scenarioId,int organisationId,int userId, int partitionId, int partitionCount, CancellationToken cancellationToken = default(CancellationToken))
        {
            var message = GetRequestMessage(HttpMethod.Post, UploadUrl, new UploadPayload
            {
                ScenarioId = scenarioId,
                OrganisationId = organisationId,
                UserId = userId,
                PartitionId = partitionId,
                PartitionCount = partitionCount
            });

            var response = await Client.SendAsync(message, cancellationToken);
            response.EnsureSuccessStatusCode();
        }

        private HttpRequestMessage GetRequestMessage<T>(HttpMethod method, string url, T payload)
        {
            var requestMessage = new HttpRequestMessage(method, url)
            {
                Content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json")
            };
            requestMessage.Headers.TryAddWithoutValidation("content-type", "application/json");
            requestMessage.Headers.TryAddWithoutValidation((string) "x-api-key", (string) ApiKey);
            return requestMessage;
        }
    }
}