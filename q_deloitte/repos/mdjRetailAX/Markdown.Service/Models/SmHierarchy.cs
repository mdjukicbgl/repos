using Markdown.Data.Entity;
using System.Linq;
using System.Collections.Generic;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmHierarchy
    {
        public int HierarchyId { get; set; }
        public int? ParentId { get; set; }
        public string Path { get; set; }
        public string Name { get; set; }
        public int Depth { get; set; }

        public static SmHierarchy Build(Hierarchy entity)
        {
            return new SmHierarchy
            {
                HierarchyId = entity.HierarchyId,
                Depth = entity.Depth,
                Path = entity.Path,
                ParentId = entity.ParentId,
                Name = entity.Name
            };
        }

        public static List<SmHierarchy> Build(List<Hierarchy> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}