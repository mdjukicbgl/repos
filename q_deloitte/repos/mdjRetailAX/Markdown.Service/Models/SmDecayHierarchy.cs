using System;
using System.Linq;
using System.Collections.Generic;
using Markdown.Data.Entity;
using Markdown.Data.Entity.Ephemeral;

namespace Markdown.Service.Models
{
    public class SmDecayHierarchy
    {
        private SmDecayHierarchy()
        {
        }

        public string Path { get; set; }
        public int MaxStage { get; set; }
        public int HierarchyId { get; set; }
        public int? ParentHierarchyId { get; set; }
        public string HierarchyName { get; set; }
        public SmDecayHierarchy Parent { get; set; }
        public Dictionary<Tuple<int, int>, SmDecay> Decays { get; set; } = new Dictionary<Tuple<int, int>, SmDecay>();

        public static Dictionary<int, SmDecayHierarchy> Build(IEnumerable<DecayHierarchy> entities)
        {
            if (entities == null)
                return null;

            var result = entities
                .GroupBy(x => new { x.HierarchyId, x.ParentHierarchyId, x.HierarchyName, Path = x.HierarchyPath })
                .Select(x => new SmDecayHierarchy
                {
                    MaxStage = x.Max(y => y.Stage),
                    HierarchyId = x.Key.HierarchyId,
                    HierarchyName = x.Key.HierarchyName,
                    ParentHierarchyId = x.Key.ParentHierarchyId,
                    Path = x.Key.Path,
                    Decays = x.ToDictionary(y => Tuple.Create(y.Stage, y.StageOffset), SmDecay.Build)
                })
                .ToDictionary(x => x.HierarchyId);


            foreach (var item in result.Values)
            {
                SmDecayHierarchy parent = null;
                if (item.ParentHierarchyId != null)
                    result.TryGetValue((int)item.ParentHierarchyId, out parent);
                item.Parent = parent;
            }

            return result;
        }

        public bool TryGetValue(int stage, int stageOffset, out SmDecay decay)
        {
            var hierarchy = this;
            while (hierarchy != null)
            {
                SmDecay result;
                if (Decays.TryGetValue(Tuple.Create(stage, stageOffset), out result))
                {
                    decay = result;
                    return true;
                }

                hierarchy = hierarchy.Parent;
            }

            decay = null;
            return false;
        }
    }
}