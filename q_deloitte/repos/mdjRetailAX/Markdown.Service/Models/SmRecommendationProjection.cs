using System;
using System.Linq;
using System.Collections.Generic;

using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmRecommendationProjection
    {
        public Guid RecommendationProjectionGuid { get; set; }
        public int Week { get; set; }
        public decimal Price { get; set; }
        public decimal Discount { get; set; }
        public int Quantity { get; set; }
        public decimal Revenue { get; set; }
        public decimal MarkdownCost { get; set; }
        public decimal AccumulatedMarkdownCost { get; set; }
        public int MarkdownCount { get; set; }
        public decimal Elasticity { get; set; }
        public decimal Decay { get; set; }
        public int MarkdownTypeId { get; set; }
 
        public static List<SmRecommendationProjection> Build(List<RecommendationProjection> entities)
        {
            return entities == null
                ? new List<SmRecommendationProjection>()
                : entities.Select(x => new SmRecommendationProjection
                {
                    RecommendationProjectionGuid = x.RecommendationProjectionGuid,
                    Week = x.Week,
                    Price = x.Price,
                    Discount = x.Discount,
                    Quantity = x.Quantity,
                    Revenue = x.Revenue,
                    MarkdownCost = x.MarkdownCost,
                    AccumulatedMarkdownCost = x.AccumulatedMarkdownCount,
                    MarkdownCount = x.MarkdownCount,
                    Elasticity = x.Elasticity,
                    Decay = x.Decay,
                    MarkdownTypeId = x.MarkdownTypeId
                }).ToList();
        }
    }
}