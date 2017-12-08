using Markdown.Common.Converters;
using Newtonsoft.Json;

namespace Markdown.Data.Entity.App
{
    public class Model : IBaseEntity
    {
        //[Key]
        public int ModelId { get; set; }
        public int ModelRunId { get; set; }
        public int? Week { get; set; }
        public int StageMax { get; set; }
        public int StageOffsetMax { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal? DecayMin { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal? DecayMax { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal DecayDefault { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal? ElasticityMin { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal? ElasticityMax { get; set; }
        [JsonConverter(typeof(RoundingJsonConverter))]
        public decimal ElasticityDefault { get; set; }
    }
}