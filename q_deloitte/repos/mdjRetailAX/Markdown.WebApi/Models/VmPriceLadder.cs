using System.Collections.Generic;
using System.Linq;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmPriceLadder
    {
        public int PriceLadderId { get; set; }
        public int PriceLadderTypeId { get; set; }
        public string Description { get; set; }
        public List<decimal> Values { get; set; }

        public static VmPriceLadder Build(SmPriceLadder model)
        {
            return new VmPriceLadder
            {
                PriceLadderId = model.PriceLadderId,
                Description = model.Description,
                PriceLadderTypeId = (int)model.Type,
                Values = model.Values.ToList()
            };
        }

        public static List<VmPriceLadder> Build(List<SmPriceLadder> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}