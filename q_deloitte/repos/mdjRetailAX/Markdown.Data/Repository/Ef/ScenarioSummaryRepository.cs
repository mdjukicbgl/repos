﻿﻿using System;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Threading.Tasks;
using System.Collections.Generic;

using Markdown.Common.Filtering;
using Markdown.Common.Filtering.Values;
using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef.Filtering;

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace Markdown.Data.Repository.Ef
{
    public interface IScenarioSummaryRepository : IBaseEntityRepository<ScenarioSummary>
    {
        Task<QueryResults<ScenarioSummary>> GetAll(List<IFilter> filters, List<ISort> Sorts, int pageIndex, int pageSize);

        Task<ScenarioSummary> GetSingle(int clientId, int scenarioId);


    }

    public class ScenarioSummaryRepository : BaseEntityRepository<ScenarioSummary>, IScenarioSummaryRepository
    {
        private readonly EnumMap<ScenarioSummaryKey, ScenarioSummary> _map = new EnumMap<ScenarioSummaryKey, ScenarioSummary>();

        public ScenarioSummaryRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
            _map.Add(ScenarioSummaryKey.ScenarioId, x => x.ScenarioId);
            _map.Add(ScenarioSummaryKey.ScenarioName, x => x.ScenarioName);
            _map.Add(ScenarioSummaryKey.ProductCount, x => x.ProductCount);
            _map.Add(ScenarioSummaryKey.RecommendationCount, x => x.RecommendationCount);
            _map.Add(ScenarioSummaryKey.LastRunDate, x => x.LastRunDateWithoutTime);
            _map.Add(ScenarioSummaryKey.Status, x => x.ScenarioSummaryStatusTypeName);
            _map.Add(ScenarioSummaryKey.Duration, x => x.Duration);
            _map.Add(ScenarioSummaryKey.PartitionTotal, x => x.FunctionInstanceCountTotal);
            _map.Add(ScenarioSummaryKey.PartitionCount, x => x.FunctionInstanceCount);
            _map.Add(ScenarioSummaryKey.PartitionErrorCount, x => x.ErrorCount);
            _map.Add(ScenarioSummaryKey.PartitionSuccessCount, x => x.SuccessCount);
        }

        public async Task<QueryResults<ScenarioSummary>> GetAll(List<IFilter> filters, List<ISort> sorts, int pageIndex, int pageSize)
        {                                                   
            var query = Context.ScenarioSummaries
                               .Include(x => x.Scenario).AsQueryable();

            if (filters.Any())
                query = Filter(query, _map, filters);

			if (sorts != null && sorts.Any())
				query = OrderBy(query, _map, sorts);
            
			var items = await query
                .Select(t => t)
                .Skip((pageIndex - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

			var total = query.Count();

            return new QueryResults<ScenarioSummary>
			{
                Items = items,
				PageIndex = pageIndex,
				PageSize = pageSize,
                Total = total
			};
        }

        public async Task<ScenarioSummary> GetSingle(int clientId, int scenarioId)
        {
            var result = await Context.ScenarioSummaries
                .Include(x => x.Scenario)
                .AsQueryable()
                .Where(x => x.ScenarioId == scenarioId)
                .FirstOrDefaultAsync();

            return result;
        }

		public static IQueryable<ScenarioSummary> Filter(IQueryable<ScenarioSummary> query, EnumMap<ScenarioSummaryKey, ScenarioSummary> map, List<IFilter> filters)
		{
			var operators = new List<OperatorGroup>();

			foreach (var filter in filters)
			{
				if (!Enum.TryParse(filter.Key, true, out ScenarioSummaryKey key))
					throw new Exception("Unknown filter key in repository");
				var mappedKey = map.Resolve(key);

			    operators.Add(BuildOperatorGroup(mappedKey, filter));
			}

			var parameterOfT = Expression.Parameter(typeof(ScenarioSummary), "x");

			var expression = operators.ToExpression(parameterOfT);
			var finalSelector = Expression.Lambda<Func<ScenarioSummary, bool>>(expression, parameterOfT);

            return query.Where(finalSelector);
		}

		public static IQueryable<Tpe> OrderBy<Tpe>(IQueryable<Tpe> query, EnumMap<ScenarioSummaryKey, Tpe> map, List<ISort> sorts)
		{
			foreach (var sort in sorts)
			{
				if (!Enum.TryParse(sort.Key, true, out ScenarioSummaryKey key))
					throw new Exception("Unknown filter key in repository");

				var propertyName = map.Resolve(key);

				query = Order(query, sort, propertyName);
			}

			return query;
		}
    }

    public class EnumMap<TEnum, TEntity> where TEnum: struct
    {
        private readonly Dictionary<TEnum, string> _map = new Dictionary<TEnum, string>();
        
        public void Add(TEnum key, Expression<Func<TEntity, object>> exp)
        {
            var body = exp.Body as MemberExpression;
            if (body == null)
            {
                var ubody = (UnaryExpression)exp.Body;
                body = ubody.Operand as MemberExpression;
            }

            if (body == null)
                throw new Exception("Unable to determine expression name. Is this a public property?");

            var path = string.Join(".", body.ToString().Split('.').Skip(1));

            _map.Add(key, path);
        }

        public string Resolve(TEnum key)
        {
            if (!_map.TryGetValue(key, out string result))
                throw new Exception("Unable to resolve " + key + " to property name. Did you add it?");
            return result;
        }
    }

}



