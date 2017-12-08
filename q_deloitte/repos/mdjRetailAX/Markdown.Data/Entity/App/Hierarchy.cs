using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class Hierarchy : IBaseEntity
    {
        [Key]
        public int HierarchyId { get; set; }
        public int? ParentId { get; set; }
        public int Depth { get; set; }
        public string Name { get; set; }
        public string Path { get; set; }
    }
}
