using Markdown.Data.Entity;
using Markdown.Data.Entity.Ephemeral;

namespace Markdown.Service.Models
{
    public class SmElasticity
    {
        private SmElasticity()
        {
        }

        public int Stage { get; set; }
        public decimal PriceElasticity { get; set; }
        public int Children { get; set; }
        public int Quantity { get; set; }

        public static SmElasticity Build(ElasticityHierarchy entity)
        {
            if (entity == null)
                return null;

            return new SmElasticity
            {
                Stage = entity.Stage,
                PriceElasticity = entity.PriceElasticity,
                Children = entity.Children,
                Quantity = entity.Quantity
            };
        }
    }
}