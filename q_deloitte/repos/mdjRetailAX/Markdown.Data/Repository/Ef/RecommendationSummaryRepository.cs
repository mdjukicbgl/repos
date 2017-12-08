using System;
using System.Linq;
using System.Threading.Tasks;
using System.Linq.Expressions;
using System.Collections.Generic;

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Markdown.Common.Filtering;
using Markdown.Common.Filtering.Values;

using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef.Filtering;
using System.Reflection;

namespace Markdown.Data.Repository.Ef
{
	public interface IRecommendationProductSummaryRepository : IBaseEntityRepository<RecommendationProductSummary>
	{
	    Task<RecommendationProductSummary> GetByRecommendationGuid(int clientId, Guid recommendationGuid);
	    Task<RecommendationProductSummary> GetByScenarioAndProductId(int clientId, int scenarioId, int productId);
        Task<QueryResults<RecommendationProductSummary>> GetAll(int scenarioId, int pageIndex, int pageSize, List<IFilter> filters, List<ISort> sorts);
		Task<List<string>> GetMultiSelectValues(int scenarioId,
													 IMultiSelectField field
												   );
	}

	public class RecommendationProductSummaryRepository : BaseEntityRepository<RecommendationProductSummary>, IRecommendationProductSummaryRepository
	{
		private readonly EnumMap<RecommendationsKey, RecommendationProductSummary> _recommendationMap = new EnumMap<RecommendationsKey, RecommendationProductSummary>();

	    public async Task<RecommendationProductSummary> GetByRecommendationGuid(int clientId, Guid recommendationGuid)
        {
	        var entity = await Context.RecommendationProductSummary
                .Include(x => x.DecisionRecommendation)
	            .Where(x => x.DecisionRecommendationGuid == recommendationGuid)
	            .SingleOrDefaultAsync();
	        return entity;
	    }

	    public async Task<RecommendationProductSummary> GetByScenarioAndProductId(int clientId, int scenarioId, int productId)
	    {
	        var entity = await Context.RecommendationProductSummary
	            .Include(x => x.DecisionRecommendation)
                .Where(x => x.ScenarioId == scenarioId && x.ProductId == productId)
                .OrderBy(x => x.ProductName)
	            .FirstOrDefaultAsync();
	        return entity;
	    }

        public RecommendationProductSummaryRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
            _recommendationMap.Add(RecommendationsKey.OriginalSellingPrice, x => x.OriginalSellingPrice);
            _recommendationMap.Add(RecommendationsKey.CurrentSellingPrice, x => x.CurrentSellingPrice);
            _recommendationMap.Add(RecommendationsKey.SellThroughTarget, x => x.SellThroughTarget);
            _recommendationMap.Add(RecommendationsKey.TerminalStock, x => x.DecisionRecommendation.TerminalStock);
            _recommendationMap.Add(RecommendationsKey.TotalRevenue, x => x.DecisionRecommendation.TotalRevenue);
            _recommendationMap.Add(RecommendationsKey.ProductName, x => x.ProductName);
            _recommendationMap.Add(RecommendationsKey.ProductId, x => x.ProductId);
            _recommendationMap.Add(RecommendationsKey.HierarchyName, x => x.HierarchyName);
            _recommendationMap.Add(RecommendationsKey.MarkdownCost, x => x.DecisionRecommendation.TotalMarkdownCost);
            _recommendationMap.Add(RecommendationsKey.Status, x => x.DecisionStateName);

            _recommendationMap.Add(RecommendationsKey.Price1, x => x.DecisionRecommendation.Price1);
            _recommendationMap.Add(RecommendationsKey.Discount1, x => x.DecisionRecommendation.Discount1);
            _recommendationMap.Add(RecommendationsKey.Price2, x => x.DecisionRecommendation.Price2);
            _recommendationMap.Add(RecommendationsKey.Discount2, x => x.DecisionRecommendation.Discount2);
            _recommendationMap.Add(RecommendationsKey.Price3, x => x.DecisionRecommendation.Price3);
            _recommendationMap.Add(RecommendationsKey.Discount3, x => x.DecisionRecommendation.Discount3);
            _recommendationMap.Add(RecommendationsKey.Price4, x => x.DecisionRecommendation.Price4);
            _recommendationMap.Add(RecommendationsKey.Discount4, x => x.DecisionRecommendation.Discount4);
            _recommendationMap.Add(RecommendationsKey.Price5, x => x.DecisionRecommendation.Price5);
            _recommendationMap.Add(RecommendationsKey.Discount5, x => x.DecisionRecommendation.Discount5);
            _recommendationMap.Add(RecommendationsKey.Price6, x => x.DecisionRecommendation.Price6);
            _recommendationMap.Add(RecommendationsKey.Discount6, x => x.DecisionRecommendation.Discount6);
            _recommendationMap.Add(RecommendationsKey.Price7, x => x.DecisionRecommendation.Price7);
            _recommendationMap.Add(RecommendationsKey.Discount7, x => x.DecisionRecommendation.Discount7);
            _recommendationMap.Add(RecommendationsKey.Price8, x => x.DecisionRecommendation.Price8);
            _recommendationMap.Add(RecommendationsKey.Discount8, x => x.DecisionRecommendation.Discount8);
            _recommendationMap.Add(RecommendationsKey.Price9, x => x.DecisionRecommendation.Price9);
            _recommendationMap.Add(RecommendationsKey.Discount9, x => x.DecisionRecommendation.Discount9);
            _recommendationMap.Add(RecommendationsKey.Price10, x => x.DecisionRecommendation.Price10);
            _recommendationMap.Add(RecommendationsKey.Discount10, x => x.DecisionRecommendation.Discount10);
        }

		public async Task<QueryResults<RecommendationProductSummary>> GetAll(int scenarioId, int pageIndex, int pageSize, List<IFilter> filters, List<ISort> sorts)
		{
		    var query = Context
		        .RecommendationProductSummary
                .Include(x => x.DecisionRecommendation)
                .Where(x => x.ScenarioId == scenarioId);

			if (filters != null && filters.Any())
                query = Filter(query, _recommendationMap, filters);

			if (sorts != null && sorts.Any())
				query = OrderBy(query, _recommendationMap, sorts);
            
			var items = await query.Skip((pageIndex - 1) * pageSize)
								  .Take(pageSize).ToListAsync();

			var total = query.Count();

			return new QueryResults<RecommendationProductSummary>
			{
				Items = items,
				PageIndex = pageIndex,
				PageSize = pageSize,
				Total = total
			};
		}


		public async Task<List<string>> GetMultiSelectValues(int scenarioId, IMultiSelectField field)
		{
			var query = Context.RecommendationProductSummary.Where(x => x.ScenarioId == scenarioId);

            var distinctStringQuery = DistinctFieldValues(query, _recommendationMap, field);

           var results = await distinctStringQuery.ToListAsync();

            return results;
		}


		public static IQueryable<RecommendationProductSummary> Filter(IQueryable<RecommendationProductSummary> query, EnumMap<RecommendationsKey, RecommendationProductSummary> map, List<IFilter> filters)
		{
			var operators = new List<OperatorGroup>();

			foreach (var filter in filters)
			{
				if (!Enum.TryParse(filter.Key, true, out RecommendationsKey key))
					throw new Exception("Unknown filter key in repository");
				var mappedKey = map.Resolve(key);

				operators.Add(BuildOperatorGroup(mappedKey, filter));
			}

			var parameterOfT = Expression.Parameter(typeof(RecommendationProductSummary), "x");

			var expression = operators.ToExpression(parameterOfT);
			var finalSelector = Expression.Lambda<Func<RecommendationProductSummary, bool>>(expression, parameterOfT);

			return query.Where(finalSelector);
		}

		public static IQueryable<T> OrderBy<T>(IQueryable<T> query, EnumMap<RecommendationsKey, T> map, List<ISort> sorts)
		{
			foreach (var sort in sorts)
			{
				if (!Enum.TryParse(sort.Key, true, out RecommendationsKey key))
					throw new Exception("Unknown filter key in repository");

			    var propertyName = map.Resolve(key);

                query = Order(query, sort, propertyName);
			}

			return query;
		}

        public static IQueryable<string> DistinctFieldValues<T>(IQueryable<T> query, EnumMap<RecommendationsKey, T> map, IMultiSelectField field)
		{
			if (!Enum.TryParse(field.Key, true, out RecommendationsKey key))
				throw new Exception("Unknown multi-select key in repository");

			var propertyName = map.Resolve(key);

			Type t = typeof(RecommendationProductSummary);
			PropertyInfo property = t.GetProperty(propertyName);

            var resultQuery = query.Select(ds => Convert.ToString(property.GetValue(ds))).Distinct().OrderBy(x=>x);
			
			return resultQuery;
		}
    }
}
