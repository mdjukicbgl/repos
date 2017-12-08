using System;

namespace Markdown.WebApi.Models
{
    public class VmControlUpload
    {
        public int ScenarioId { get; set; }
        public int PartitionId { get; set; }
        public int PartitionCount { get; set; }
    }
}