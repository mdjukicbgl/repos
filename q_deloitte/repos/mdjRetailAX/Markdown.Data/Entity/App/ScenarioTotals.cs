using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace Markdown.Data.Entity.App
{
    public class ScenarioTotals: IBaseEntity
    {
		[ForeignKey("Scenario")]
		public int ScenarioId { get; set; }

		public decimal ProductsCost { get; set; }
        public decimal ProductsAcceptedCost { get; set; }
        public int ProductsAcceptedCount { get; set; }
        public int ProductsRejectedCount { get; set; }
		public int OrganisationId { get; set; }
	}
}
