namespace Markdown.Common.Settings.Interfaces
{
    public interface IFileUploadSettings
    {
        string BucketName { get; set; }
        string PathTemplate { get; set; }
        int ExpiryMinutes { get; set; }
    }
}