using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;

namespace Markdown.Data.Entity.Json
{
    public class FunctionInstancePartitionJson : FunctionInstanceJson
    {
        public FunctionInstancePartitionJson(ICloudWatchSettings cloudSettings) : base(cloudSettings)
        {
        }
    }
}