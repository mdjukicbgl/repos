using System.Collections.Generic;
using System.Linq;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmRecommendationProjectionSummary
    {
        public int Week { get; set; }
        public decimal Price { get; set; }
        public decimal Discount { get; set; }
        public int Quantity { get; set; }
    
        public static List<SmRecommendationProjectionSummary> Build(List<RecommendationProjectionSummary> entities)
        {
            return entities == null
                ? new List<SmRecommendationProjectionSummary>()
                : entities.Select(x => new SmRecommendationProjectionSummary
                { Week = x.Week,
                    Price = x.Price,
                    Discount = x.Discount,
                    Quantity = x.Quantity
                }).ToList();
        }
    }
}