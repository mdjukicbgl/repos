using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class ScenarioHierarchyFilter : IBaseEntity
    {
        [Key]
        public int ScenarioHierarchyFilterId { get; set; }
        public int ScenarioId { get; set; }
        public int HierarchyId { get; set; }

        public virtual Scenario Scenario { get; set; }
    }
}