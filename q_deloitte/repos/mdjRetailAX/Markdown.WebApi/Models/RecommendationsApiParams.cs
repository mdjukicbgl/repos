using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

using Markdown.Common.Filtering;
using Markdown.Common.Filtering.Values;
using Markdown.WebApi.Models.Validators;

namespace Markdown.WebApi.Models
{
    public class RecommendationsApiParams: ApiParamsBase, IValidatableObject
    {
        public string HierarchyName { get; set; }
		public string ProductName { get; set; }
        public string ProductId { get; set; }
		public string OriginalSellingPrice { get; set; }
        public string CurrentSellingPrice { get; set; }
		public string SellThroughTarget { get; set; }
		public string TerminalStock { get; set; }
		public string TotalRevenue { get; set; }

        public string Price1 { get; set; }
        public string Discount1 { get; set; }
		public string Price2 { get; set; }
		public string Discount2 { get; set; }
		public string Price3 { get; set; }
		public string Discount3 { get; set; }
		public string Price4 { get; set; }
		public string Discount4 { get; set; }

		public string Price5 { get; set; }
		public string Discount5 { get; set; }
		public string Price6 { get; set; }
		public string Discount6 { get; set; }
		public string Price7 { get; set; }
		public string Discount7 { get; set; }
		public string Price8 { get; set; }
		public string Discount8 { get; set; }
		public string Price9 { get; set; }
		public string Discount9 { get; set; }
		public string Price10 { get; set; }
		public string Discount10 { get; set; }

        public string MarkdownCost { get; set; }
        public string DecisionStateName { get; set; }


		private List<IFilter> Filters
		{
			get
			{
				var filters = new List<IFilter>
					{
                        QueryParser.FilterBy(RecommendationsKey.OriginalSellingPrice, OriginalSellingPrice, decimal.Parse),
                        QueryParser.FilterBy(RecommendationsKey.CurrentSellingPrice, CurrentSellingPrice, decimal.Parse),
                        QueryParser.FilterBy(RecommendationsKey.SellThroughTarget, SellThroughTarget, decimal.Parse),
                        QueryParser.FilterBy(RecommendationsKey.TerminalStock, TerminalStock, int.Parse),
                        QueryParser.FilterBy(RecommendationsKey.TotalRevenue, TotalRevenue, decimal.Parse),
                        QueryParser.FilterBy(RecommendationsKey.HierarchyName, HierarchyName, x=>x),
                        QueryParser.FilterBy(RecommendationsKey.ProductName, ProductName, x=>x),
                        QueryParser.FilterBy(RecommendationsKey.Price1, Price1, decimal.Parse),
                        QueryParser.FilterBy(RecommendationsKey.Discount1, Discount1, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price2, Price2, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount2, Discount2, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price3, Price3, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount3, Discount3, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price4, Price4, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount4, Discount4, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price5, Price5, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount5, Discount5, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Price6, Price6, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount6, Discount6, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price7, Price7, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount7, Discount7, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price8, Price8, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount8, Discount8, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price9, Price9, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount9, Discount9, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Price10, Price10, decimal.Parse),
						QueryParser.FilterBy(RecommendationsKey.Discount10, Discount10, decimal.Parse),
                        QueryParser.FilterBy(RecommendationsKey.ProductId, ProductId, int.Parse),
					    QueryParser.FilterBy(RecommendationsKey.MarkdownCost, MarkdownCost, decimal.Parse),
					    QueryParser.FilterBy(RecommendationsKey.Status, DecisionStateName, x=>x)
                    };

				return filters;
			}
		}

		public List<IFilter> GetValidFilters()
		{
			return Filters.Where(x => x != null).ToList();
		}

		private List<ISort> Sorts => QueryParser.SortBy<RecommendationsKey>(Sort);

        public List<ISort> GetSorts()
		{
			return Sorts;
		}

        public IMultiSelectField GetMultiSelectField()
        {
            return new MultiSelectField { Key= MultiSelectKey };
        }

		public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
        {
			var validator = new RecommendationsApiParamsValidator();
			var result = validator.Validate(this);
			return result.Errors.Select(item => new ValidationResult(item.ErrorMessage, new[] { "Errors" }));
        }
    }
}
