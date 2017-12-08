using System;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmScenarioTotals
    {
		public decimal ProductsCost { get; set; }
		public decimal ProductsAcceptedCost { get; set; }
		public int ProductsAcceptedCount { get; set; }
		public int ProductsRejectedCount { get; set; }

         public static SmScenarioTotals Build(ScenarioTotals results)
        {
            return new SmScenarioTotals {
                        ProductsCost = results.ProductsCost,
                        ProductsAcceptedCost = results.ProductsAcceptedCost,
                        ProductsAcceptedCount =results.ProductsAcceptedCount,
                        ProductsRejectedCount = results.ProductsRejectedCount
                        };
        }
    }
}
