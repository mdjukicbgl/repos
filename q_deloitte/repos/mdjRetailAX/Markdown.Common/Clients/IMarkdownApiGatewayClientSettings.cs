namespace Markdown.Common.Clients
{
    public interface IMarkdownApiGatewayClientSettings
    {
        string ApiKey { get; set; }
        string BaseUrl { get; set; }
    }
}
