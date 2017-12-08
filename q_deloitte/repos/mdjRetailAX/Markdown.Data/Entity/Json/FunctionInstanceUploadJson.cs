using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;

namespace Markdown.Data.Entity.Json
{
    public class FunctionInstanceUploadJson : FunctionInstanceJson
    {
        public FunctionInstanceUploadJson(ICloudWatchSettings cloudSettings) : base(cloudSettings)
        {
        }
    }
}