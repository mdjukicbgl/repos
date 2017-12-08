using System.Collections.Generic;
using System.Linq;
using Markdown.Common.Extensions;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmRecommendationProjection
    {
        public decimal Price { get; set; }
        public decimal Discount { get; set; }
        public decimal Quantity { get; set; }
		public int Week { get; set; }
        public bool IsCsp { get; set; }
        public bool IsPadding { get; set; }
        public bool IsMarkdown { get; set; }

        public static VmRecommendationProjection Build(SmRecommendationSummary recommendation, SmRecommendationProjectionSummary model, int index)
        {
            if (model == null)
                return null;

            var isMarkdown = (recommendation.ScheduleMask & (1 << index)) != 0;

            var isCsp = true;
            var isPadding = true;

            if (recommendation.ScheduleId > 0)
            {
                var bits = recommendation.ScheduleId.GetBitIndexes().ToList();
                isCsp = index < bits.First();
                isPadding = index > bits.Last();
            }

            return new VmRecommendationProjection
            {
                Week = model.Week,
                Discount = model.Discount,
                Price = model.Price,
                Quantity = model.Quantity,
                IsCsp = isCsp,
                IsPadding = isPadding,
                IsMarkdown = isMarkdown
            };
        }

        public static List<VmRecommendationProjection> Build(SmRecommendationSummary recommendation, List<SmRecommendationProjectionSummary> models)
        {
            return recommendation == null || models == null ? new List<VmRecommendationProjection>() : models.Select((x, i) => Build(recommendation, x, i)).ToList();
        }
    }
}



