using System.Collections.Generic;

using Markdown.Data.Entity;
using Markdown.Data.Entity.Ephemeral;

namespace Markdown.Service.Models
{
    public class SmModelData
    {
        public Dictionary<int, SmDecayHierarchy> DecayHierarchies { get; private set; } = new Dictionary<int, SmDecayHierarchy>();
        public Dictionary<int, SmElasticityHierarchy> ElasticityHierarchies { get; private set; } = new Dictionary<int, SmElasticityHierarchy>();
      
        public static SmModelData Build(List<ElasticityHierarchy> elasticity, List<DecayHierarchy> decay)
        {
            return new SmModelData
            {
                DecayHierarchies = SmDecayHierarchy.Build(decay),
                ElasticityHierarchies = SmElasticityHierarchy.Build(elasticity)
            };
        }
    }
}