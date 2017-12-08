using Markdown.Common.Clients;

namespace Markdown.WebApi
{
    public class MarkdownApiGatewayClientSettings : IMarkdownApiGatewayClientSettings
    {
        public string ApiKey { get; set; }
        public string BaseUrl { get; set; }

        public MarkdownApiGatewayClientSettings(string apiKey, string baseUrl)
        {
            ApiKey = apiKey;
            BaseUrl = baseUrl;
        }
    }
}