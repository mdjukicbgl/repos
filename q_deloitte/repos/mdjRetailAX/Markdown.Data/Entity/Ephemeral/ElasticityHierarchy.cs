using Markdown.Common.Converters;
using Newtonsoft.Json;

namespace Markdown.Data.Entity.Ephemeral
{
    public class ElasticityHierarchy
	{
		public string HierarchyPath { get; set; }
		public int Stage { get; set; }
		public int HierarchyId { get; set; }
        public int ParentHierarchyId { get; set; }
		public string HierarchyName { get; set; }
		public int Children { get; set; }
		public int Quantity { get; set; }
	    [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal Price { get; set; }
	    [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal PriceElasticity { get; set; }
    }
}
