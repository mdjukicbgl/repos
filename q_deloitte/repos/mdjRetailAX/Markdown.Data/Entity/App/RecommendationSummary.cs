using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Markdown.Data.Entity.App
{
	public class RecommendationSummary : IBaseEntity
	{
	    public static JsonSerializerSettings JsonSerializerSettings = new JsonSerializerSettings
	    {
	        ContractResolver = new DefaultContractResolver {NamingStrategy = new SnakeCaseNamingStrategy()}
	    };

	    [Key]
        public Guid RecommendationSummaryGuid { get; set; }
	    public Guid RecommendationProductGuid { get; set; }

	    public int ClientId { get; set; }
	    public int ScenarioId { get; set; }
	    public int ProductId { get; set; }
        public int OrganisationId { get; set; }

        public int ScheduleId { get; set; }
	    public int ScheduleMask { get; set; }
	    public int ScheduleMarkdownCount { get; set; }
	    public bool IsCsp { get; set; }
	    public string PricePathPrices { get; set; }
	    public int PricePathHashCode { get; set; }
	    public int RevisionId { get; set; }

	    public int Rank { get; set; }
	    public int TotalMarkdownCount { get; set; }
	    public int TerminalStock { get; set; }
	    public decimal TotalRevenue { get; set; }
	    public decimal TotalCost { get; set; }
	    public decimal TotalMarkdownCost { get; set; }
        public decimal? FinalDiscount { get; set; }
	    public decimal StockValue { get; set; }
	    public decimal EstimatedProfit { get; set; }
	    public decimal EstimatedSales { get; set; }
	    public decimal SellThroughRate { get; set; }
	    public decimal SellThroughTarget { get; set; }
	    public int FinalMarkdownTypeId { get; set; }

	    private List<RecommendationProjectionSummary> _projections = null;

        [NotMapped]
        public List<RecommendationProjectionSummary> Projections {
            get
            {
                if (_projections != null)
                    return _projections;

                return _projections = Weeks.Select((x, i) => new RecommendationProjectionSummary
                {
                    Week = Weeks[i],
                    Price = Prices[i],
                    Discount = Discounts[i],
                    Quantity = Quantities[i]
                }).ToList();
            }
        }

	    public int[] Weeks { get; set; }
	    public decimal[] Prices { get; set; }
	    public decimal[] Discounts { get; set; }
        public int[] Quantities { get; set; }

        public int? Week1 { get; set; }
		public decimal? Discount1 { get; set; }
		public decimal? Price1 { get; set; }

		public int? Week2 { get; set; }
		public decimal? Discount2 { get; set; }
		public decimal? Price2 { get; set; }

		public int? Week3 { get; set; }
		public decimal? Discount3 { get; set; }
		public decimal? Price3 { get; set; }

		public int? Week4 { get; set; }
		public decimal? Discount4 { get; set; }
		public decimal? Price4 { get; set; }

		public int? Week5 { get; set; }
		public decimal? Discount5 { get; set; }
		public decimal? Price5 { get; set; }

		public int? Week6 { get; set; }
		public decimal? Discount6 { get; set; }
		public decimal? Price6 { get; set; }

		public int? Week7 { get; set; }
		public decimal? Discount7 { get; set; }
		public decimal? Price7 { get; set; }

		public int? Week8 { get; set; }
		public decimal? Discount8 { get; set; }
		public decimal? Price8 { get; set; }

		public int? Week9 { get; set; }
		public decimal? Discount9 { get; set; }
		public decimal? Price9 { get; set; }

		public int? Week10 { get; set; }
		public decimal? Discount10 { get; set; }
		public decimal? Price10 { get; set; }
	}
}
