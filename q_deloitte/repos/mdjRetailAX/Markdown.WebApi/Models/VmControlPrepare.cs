using System;

namespace Markdown.WebApi.Models
{
    public class VmControlPrepare
    {
        public int ModelId { get; set; }
        public int ModelRunId { get; set; }
        public int ScenarioId { get; set; }
        public int PartitionCount { get; set; }
        public bool Calculate { get; set; }
        public bool Upload { get; set; }
    }
}