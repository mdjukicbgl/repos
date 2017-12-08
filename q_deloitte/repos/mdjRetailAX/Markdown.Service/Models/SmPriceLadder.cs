using System.Linq;
using System.Collections.Generic;

using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmPriceLadder
    {
        public int PriceLadderId { get; set; }
        public SmPriceLadderType Type { get; set; }
        public string Description { get; set; }
        public decimal[] Values { get; set; } = new decimal[0];

        public static SmPriceLadder Build(PriceLadder entity)
        {
            if (entity == null)
                return null;

            return new SmPriceLadder
            {
                PriceLadderId = entity.PriceLadderId,
                Type = (SmPriceLadderType)entity.PriceLadderTypeId,
                Description = entity.Description,
                Values = entity.Values.OrderBy(y => y.Order).Select(z => z.Value).ToArray()
            };
        }

        public static List<SmPriceLadder> Build(List<Data.Entity.Ephemeral.PriceLadderValue> entities)
        {
            return entities.GroupBy(x => x.PriceLadderId, (x, g) =>
            {
                var values = g.ToList();
                var first = values.First();

                return new SmPriceLadder
                {
                    PriceLadderId = x,
                    Type = (SmPriceLadderType)first.PriceLadderTypeId,
                    Values = values.OrderBy(y => y.Order).Select(z => z.Value).ToArray()
                };

            }).ToList();
        }
    }
}