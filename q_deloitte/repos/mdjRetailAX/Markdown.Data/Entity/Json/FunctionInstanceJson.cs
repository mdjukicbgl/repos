using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;

namespace Markdown.Data.Entity.Json
{
    public class FunctionInstanceJson : ICloudWatchSettings
    {
        public string FunctionName { get; set; }
        public string FunctionVersion { get; set; }
        public string LogGroupName { get; set; }
        public string LogStreamName { get; set; }

        public string ErrorMessage { get; set; }

        public FunctionInstanceJson(ICloudWatchSettings cloudSettings)
        {
            FunctionName = cloudSettings.FunctionName;
            FunctionVersion = cloudSettings.FunctionVersion;
            LogGroupName = cloudSettings.LogGroupName;
            LogStreamName = cloudSettings.LogStreamName;
        }
    }
}