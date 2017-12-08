using System.Collections.Generic;

namespace Markdown.WebApi.Models
{
    public class VmScenarioRevisionCreate
    {
        public List<VmScenarioRevision> Revisions { get; set; } = new List<VmScenarioRevision>();
    }
}