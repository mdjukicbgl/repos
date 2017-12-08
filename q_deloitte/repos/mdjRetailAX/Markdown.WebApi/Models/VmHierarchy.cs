using System.Linq;
using System.Collections.Generic;

using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmHierarchy
    {
        public int HierarchyId { get; set; }
        public int? ParentId { get; set; }
        public string Path { get; set; }
        public string Name { get; set; }
        public int Depth { get; set; }

        public static VmHierarchy Build(SmHierarchy model)
        {
            return new VmHierarchy
            {
                HierarchyId = model.HierarchyId,
                Depth = model.Depth,
                Path = model.Path,
                ParentId = model.ParentId,
                Name = model.Name
            };
        }

        public static List<VmHierarchy> Build(List<SmHierarchy> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}
