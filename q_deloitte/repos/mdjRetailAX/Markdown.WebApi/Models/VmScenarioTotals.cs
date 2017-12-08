using System;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmScenarioTotals
    {
		public decimal ProductsCost { get; set; }
		public decimal ProductsAcceptedCost { get; set; }
		public int ProductsAcceptedCount { get; set; }
		public int ProductsRejectedCount { get; set; }

        public static VmScenarioTotals Build(SmScenarioTotals results)
        {
            return new VmScenarioTotals {
							ProductsCost = results.ProductsCost,
							ProductsAcceptedCost = results.ProductsAcceptedCost,
							ProductsAcceptedCount = results.ProductsAcceptedCount,
							ProductsRejectedCount = results.ProductsRejectedCount
                    };
        }
    }
}
