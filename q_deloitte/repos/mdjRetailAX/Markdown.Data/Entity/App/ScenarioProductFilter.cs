using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class ScenarioProductFilter : IBaseEntity
    {
        [Key]
        public int ScenarioProductFilterId { get; set; }
        public int ScenarioId { get; set; }
        public int ProductId { get; set; }

        public virtual Scenario Scenario { get; set; }
    }
}