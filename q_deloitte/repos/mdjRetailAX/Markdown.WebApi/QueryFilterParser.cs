﻿using System;
using System.Linq;
using System.Net;
using System.Collections.Generic;
 using Markdown.Common.Extensions;
 using Markdown.Common.Filtering;
using Markdown.Common.Filtering.Values;

namespace Markdown.WebApi
{
    public static class QueryParser
    {
        public static IFilter FilterBy<TEnum, TValue>(TEnum name, 
                                                      string queryValue, 
                                                      Func<string, TValue> validate,
                                                      BinaryOperatorType operatorType = BinaryOperatorType.Or,
                                                      BinaryOperatorType nextOperatorType=BinaryOperatorType.And) where TEnum: struct
        {
            if (string.IsNullOrWhiteSpace(queryValue))
                return null;
            
            var right = queryValue.Split(new char[] { ':' }, 2);
            var opString = right[0];

            try
            {
                var trimmedValue = right[1].Trim();

				if (!Enum.TryParse(opString, true, out FilterOperator op))
                    throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);

                switch (op)
                {
                    case FilterOperator.In:
                        var values = trimmedValue.Split(',').Select(x=>x.Trim()).Select(validate).ToList();
                        return Filter.Build(FilterOperator.In, name.ToString(), values);
                    case FilterOperator.Nin:
                        var ninValues = trimmedValue.Split(',').Select(x => x.Trim()).Select(validate).ToList();
                        return Filter.Build(FilterOperator.Nin, name.ToString(), ninValues);
                    case FilterOperator.Gt:
                        return Filter.Build(FilterOperator.Gt, name.ToString(), validate(trimmedValue),operatorType,nextOperatorType);
                    case FilterOperator.Lt:
                        return Filter.Build(FilterOperator.Lt, name.ToString(), validate(trimmedValue),operatorType,nextOperatorType);
					case FilterOperator.Ge:
						return Filter.Build(FilterOperator.Ge, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
					case FilterOperator.Le:
						return Filter.Build(FilterOperator.Le, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
					case FilterOperator.Eq:
						return Filter.Build(FilterOperator.Eq, name.ToString(), validate(trimmedValue),operatorType,nextOperatorType);
					case FilterOperator.Neq:
						return Filter.Build(FilterOperator.Neq, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
                    case FilterOperator.Inc:
                        return Filter.Build(FilterOperator.Inc, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
					case FilterOperator.Ninc:
                        return Filter.Build(FilterOperator.Ninc, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
					case FilterOperator.Sw:
						return Filter.Build(FilterOperator.Sw, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
					case FilterOperator.Ew:
						return Filter.Build(FilterOperator.Ew, name.ToString(), validate(trimmedValue), operatorType, nextOperatorType);
					default:
                        throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);
                }
            }
            catch (Exception ex)
            {
                if (ex is ArgumentException || ex is FormatException || ex is OverflowException)
                    throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);
                throw ex;
            }
        }

        public static List<ISort> SortBy<TEnum>(string queryValue) where TEnum : struct
        {
            var result = new List<ISort>();

            if (string.IsNullOrWhiteSpace(queryValue))
                return result;

            try
            {
                foreach (var pair in queryValue.Split(','))
                {
                    if (string.IsNullOrWhiteSpace(pair))
                        throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);

                    var values = pair.Split(':');
                    if (values.Length == 0 || values.Length > 2)
                        throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);

                    if (!Enum.TryParse(values[0], true, out TEnum op))
                        throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);

                    var direction = values.Length > 1
                        ? (SortDirection)Enum.Parse(typeof(SortDirection), values[1], true)
                        : SortDirection.Asc;

                    result.Add(Sort.Build(op.ToString(), direction));
                }
            }
            catch (Exception ex)
            {
                if (ex is ArgumentException || ex is FormatException || ex is OverflowException)
                    throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest);
                throw;
            }

            return result;
        }
    }
}



