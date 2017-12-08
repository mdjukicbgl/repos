using Markdown.Common.Interfaces;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;

namespace Markdown.Data.Entity.Json
{
    [JsonVersion(1)]
    public class FunctionInstanceCalculateJson : FunctionInstanceJson
    {
        public double ProductRate { get; set; }
        public long ProductCount { get; set; }
        public long ProductTotal { get; set; }
        public long RecommendationCount { get; set; }
        public int HierarchyErrorCount { get; set; }

        public FunctionInstanceCalculateJson(ICloudWatchSettings cloudSettings) : base(cloudSettings)
        {
        }
    }
}