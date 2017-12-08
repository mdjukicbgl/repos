using System;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using Markdown.Common.Filtering;
using Markdown.Data.Entity;
using Markdown.Data.Repository.Ef.Filtering;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace Markdown.Data.Repository.Ef
{
    public interface IBaseEntityRepository<T> where T : class, IBaseEntity
    {
    }

    public class BaseEntityRepository<T> : IBaseEntityRepository<T> where T : class, IBaseEntity, new()
                                                                                      
    {
        protected IMarkdownEfContext Context;
        
        public BaseEntityRepository(IDbContextFactory<MarkdownEfContext> cf)
        {
            // TODO wtf
            Context = cf.Create(null);  
        }


        public static OperatorGroup BuildOperatorGroup(string mappedKey, IFilter filter)
        {
			switch (filter.Op)
			{
				case FilterOperator.In:
					 return OperatorGroup.Build(mappedKey, filter.ValueList, OperatorTestType.Eq); //Need to handle string to lower
				case FilterOperator.Nin:
                    return OperatorGroup.Build(mappedKey, filter.ValueList, OperatorTestType.Neq,OperatorTestOption.None,BinaryOperatorType.And);
				case FilterOperator.Gt:
					 return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Gt);
				case FilterOperator.Lt:
					return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Lt);
				case FilterOperator.Ge:
					return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Ge);
				case FilterOperator.Le:
					 return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Le);
				case FilterOperator.Eq:
					 return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Eq);
				case FilterOperator.Neq:
					 return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Neq);
                case FilterOperator.Inc:
                    return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Inc);
				case FilterOperator.Ninc:
					return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Ninc);
				case FilterOperator.Sw:
					return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Sw);
				case FilterOperator.Ew:
					return OperatorGroup.Build(mappedKey, filter.Value, OperatorTestType.Ew);
				default:
					throw new ArgumentOutOfRangeException();
			}
        }

		public static IQueryable<TModel> Order<TModel>(IQueryable<TModel> query, ISort sort, string propertyName)
        {
			var model = Expression.Parameter(typeof(TModel), "model");
            var propertyExpression = (MemberExpression)propertyName.Split('.').Aggregate<string, Expression>(model, Expression.PropertyOrField);

			var type = propertyExpression.Type;

            Expression hasValueExpression = null;

			if (Nullable.GetUnderlyingType(type) != null)
                hasValueExpression = (Expression)Expression.Property(propertyExpression, type.GetProperty("HasValue"));
			
			if (type == typeof(decimal))
				query = Order<decimal, TModel>(query, sort, model, propertyExpression);
			if (type == typeof(decimal?))
				query = Order<decimal?, TModel>(query, sort, model, propertyExpression,hasValueExpression);
			if (type == typeof(long))
				query = Order<long, TModel>(query, sort, model, propertyExpression);
			if (type == typeof(long?))
				query = Order<long?, TModel>(query, sort, model, propertyExpression,hasValueExpression);
			if (type == typeof(int))
				query = Order<int, TModel>(query, sort, model, propertyExpression);
			if (type == typeof(int?))
				query = Order<int?, TModel>(query, sort, model, propertyExpression,hasValueExpression);
			if (type == typeof(string))
				query = Order<string, TModel>(query, sort, model, propertyExpression);
            if (type == typeof(DateTime))
				query = Order<DateTime, TModel>(query, sort, model, propertyExpression);
			if (type == typeof(DateTime?))
				query = Order<DateTime?, TModel>(query, sort, model, propertyExpression,hasValueExpression);

            return query;
        }

		public static IOrderedQueryable<TModel> Order<TValueType, TModel>(
            IQueryable<TModel> query, ISort sort, ParameterExpression model, MemberExpression propertyExpression, Expression hasValueExpression=null)
		{
            if (sort.Direction == SortDirection.Desc && hasValueExpression != null)
                return query
                    .OrderByDescending(Expression.Lambda<Func<TModel, bool>>(hasValueExpression, model))
                    .ThenByDescending(Expression.Lambda<Func<TModel, TValueType>>(propertyExpression, model));
            
            return 
                sort.Direction == SortDirection.Asc
                    ? query.OrderBy(Expression.Lambda<Func<TModel, TValueType>>(propertyExpression, model))
                    : query.OrderByDescending(Expression.Lambda<Func<TModel, TValueType>>(propertyExpression, model));
		}
    }
}

