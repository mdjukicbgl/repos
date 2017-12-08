namespace Markdown.Common.Settings.Interfaces
{
    public interface ICloudWatchSettings
    {

        string LogGroupName { get; }
        string LogStreamName { get; }
        string FunctionName { get; set; }
        string FunctionVersion { get; set; }
    }
}