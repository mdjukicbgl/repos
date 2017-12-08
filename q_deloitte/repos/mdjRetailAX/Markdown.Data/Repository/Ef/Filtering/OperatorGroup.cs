﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using Markdown.Common.Filtering;

namespace Markdown.Data.Repository.Ef.Filtering
{
    public class OperatorGroup
    {
        public string PropertyName { get; set; }
        public BinaryOperatorType OperatorType { get; set; }
        public BinaryOperatorType NextOperatorType { get; set; }
        public List<IOperatorTest> OperatorTests { get; set; } = new List<IOperatorTest>();

        public Expression ToExpression<T>(ParameterExpression parameter)
        {
            return OperatorTests
                .Select(x => x.ToExpression(parameter, PropertyName))
                .Aggregate((a, b) =>
                {
                    switch (OperatorType)
                    {
                        case BinaryOperatorType.Or:
                            return Expression.Or(a, b);
                        case BinaryOperatorType.And:
                            return Expression.And(a, b);
                        default:
                            throw new Exception("Unknown BinaryOperator type");
                    }
                });
        }

        public static OperatorGroup Build<T>(
            string propertyName, List<T> values,
            OperatorTestType operatorTestType = OperatorTestType.Equal,
            OperatorTestOption operatorTestOptions = OperatorTestOption.None,

            BinaryOperatorType operatorType = BinaryOperatorType.Or,
            BinaryOperatorType nextOperatorType = BinaryOperatorType.And)
        {
            return new OperatorGroup
            {
                PropertyName = propertyName,
                OperatorType = operatorType,
                NextOperatorType = nextOperatorType,
                OperatorTests = values
                    .Select(x => OperatorTest.FromProperty(propertyName, x, operatorTestType, operatorTestOptions))
                    .ToList()
            };
        }

        public static OperatorGroup Build<T>(
            string propertyName, T value,
            OperatorTestType operatorTestType = OperatorTestType.Equal,
            OperatorTestOption operatorTestOptions = OperatorTestOption.None,

            BinaryOperatorType operatorType = BinaryOperatorType.Or,
            BinaryOperatorType nextOperatorType = BinaryOperatorType.And)
        {
            return new OperatorGroup
            {
                PropertyName = propertyName,
                OperatorType = operatorType,
                NextOperatorType = nextOperatorType,
                OperatorTests = new List<IOperatorTest> { OperatorTest.FromProperty(propertyName, value, operatorTestType, operatorTestOptions) }
            };
        }
    }


    public static class ListOperatorGroupExtension
    {
        public static Expression ToExpression(this List<OperatorGroup> src,
                                              ParameterExpression parameter)
        {
            Expression result = null;
            BinaryOperatorType nextOperatorType = BinaryOperatorType.Or;

            foreach (var op in src)
            {
                var expression = op.ToExpression<string>(parameter);
                if (result != null)
                {
                    switch (nextOperatorType)
                    {
                        case BinaryOperatorType.Or:
                            {
                                result = Expression.Or(result, expression);
                                nextOperatorType = op.NextOperatorType;
                            }
                            break;
                        case BinaryOperatorType.And:
                            {
                                result = Expression.And(result, expression);
								nextOperatorType = op.NextOperatorType;
                            }
                            break;
                        default:
                            throw new Exception("Unknown BinaryOperatorType NextOperatorType");
                    }
                }
                else
                {
                    result = expression;
                    nextOperatorType = op.NextOperatorType;
                }
            }

            return result;
        }
    }
}


