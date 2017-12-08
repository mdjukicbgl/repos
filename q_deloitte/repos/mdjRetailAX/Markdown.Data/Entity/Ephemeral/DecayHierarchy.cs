using Markdown.Common.Converters;
using Newtonsoft.Json;

namespace Markdown.Data.Entity.Ephemeral
{
    public class DecayHierarchy 
    {
        public string HierarchyPath { get; set; }
        public int Stage { get; set; }
        public int StageOffset { get; set; }
        public int HierarchyId { get; set; }
        public int? ParentHierarchyId { get; set; }
        public string HierarchyName { get; set; }
        public int Children { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal Decay { get; set; }
    }
}