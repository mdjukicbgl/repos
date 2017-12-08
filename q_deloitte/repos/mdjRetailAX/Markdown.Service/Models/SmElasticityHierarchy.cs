using System.Linq;
using System.Collections.Generic;
using Markdown.Data.Entity;
using Markdown.Data.Entity.Ephemeral;

namespace Markdown.Service.Models
{
    public class SmElasticityHierarchy
    {
        private SmElasticityHierarchy()
        {
        }

        public string Path { get; set; }
        public int MaxStage { get; set; }
        public int HierarchyId { get; set; }
        public int? ParentHierarchyId { get; set; }
        public string HierarchyName { get; set; }
        public SmElasticityHierarchy Parent { get; set; }
        public Dictionary<int, SmElasticity> Elasticities { get; set; } = new Dictionary<int, SmElasticity>();

        public static Dictionary<int, SmElasticityHierarchy> Build(IEnumerable<ElasticityHierarchy> entities)
        {
            if (entities == null)
                return null;

            var result = entities
                .GroupBy(x => new {x.HierarchyId, x.ParentHierarchyId, x.HierarchyName, Path = x.HierarchyPath})
                .Select(x => new SmElasticityHierarchy
                {
                    MaxStage = x.Max(y => y.Stage),
                    HierarchyId = x.Key.HierarchyId,
                    HierarchyName = x.Key.HierarchyName,
                    ParentHierarchyId = x.Key.ParentHierarchyId,
                    Path = x.Key.Path,
                    Elasticities = x.ToDictionary(y => y.Stage, SmElasticity.Build)
                })
                .ToDictionary(x => x.HierarchyId);


            foreach (var item in result.Values)
            {
                SmElasticityHierarchy parent = null;
                if (item.ParentHierarchyId != null)
                    result.TryGetValue((int)item.ParentHierarchyId, out parent);
                item.Parent = parent;
            }

            return result;
        }

        public bool TryGetValue(int stage, out SmElasticity elasticity)
        {
            var hierarchy = this;
            while (hierarchy != null)
            {
                if (Elasticities.TryGetValue(stage, out SmElasticity result))
                {
                    elasticity = result;
                    return true;
                }

                hierarchy = hierarchy.Parent;
            }

            elasticity = null;
            return false;
        }
    }
}