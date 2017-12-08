using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;

namespace Markdown.Data.Repository.Ef.Filtering
{
    public interface IOperatorTest
    {
        Expression ToExpression(ParameterExpression parameter, string propertyName);
    }

    public static class OperatorTest
    {
        public static IOperatorTest FromProperty<T>(string propertyName, T value, OperatorTestType operatorTestType, OperatorTestOption operatorTestOptions)
        {
            return new OperatorTest<T>
            {
                Value = value,
                TestType = operatorTestType,
                TestOptions = operatorTestOptions
            };
        }
    }

    public class OperatorTest<T> : IOperatorTest
    {
        public T Value { get; set; }
        public OperatorTestType TestType { get; set; }
        public OperatorTestOption TestOptions { get; set; }

        public Expression ToExpression(ParameterExpression parameter, string propertyName)
        {
            // TODO this might need to have another expression test to ensure the nagivation property isn't null if it's nullable
            var left = propertyName.Split('.').Aggregate<string, Expression>(parameter, Expression.PropertyOrField);
			var right = (Expression)Expression.Convert(Expression.Constant(Value), left.Type);

            if (left.Type == typeof(string))
            {
                left = (Expression)Expression.Call(left, typeof(string).GetMethod("ToLower", Type.EmptyTypes));
                right = (Expression)Expression.Call(right, typeof(string).GetMethod("ToLower", Type.EmptyTypes));
            }

            switch (TestType)
            {
				case OperatorTestType.Eq:
					return Expression.Equal(left, right);
                case OperatorTestType.Neq:
					return Expression.NotEqual(left, right);
                case OperatorTestType.Gt:
                    return  Expression.GreaterThan(left, right);
                case OperatorTestType.Lt:
                    return Expression.LessThan(left, right);
				case OperatorTestType.Ge:
                    return Expression.GreaterThanOrEqual(left, right);
				case OperatorTestType.Le:
					return Expression.LessThanOrEqual(left, right);
                case OperatorTestType.Inc:
                    return Expression.Call(left, typeof(string).GetMethod("Contains", new Type[] { typeof(string) }), right);
                case OperatorTestType.Ninc:
					return Expression.Not(Expression.Call(left, typeof(string).GetMethod("Contains", new Type[] { typeof(string) }), right));
				case OperatorTestType.Sw:
					return Expression.Call(left, typeof(string).GetMethod("StartsWith", new Type[] { typeof(string) }), right);
				case OperatorTestType.Ew:
					return Expression.Call(left, typeof(string).GetMethod("EndsWith", new Type[] { typeof(string) }), right);
				default:
                    throw new Exception("Unknown OperatorTestType type");
            }
        }
        
        public static object GetDefault(Type type)
        {
            return type.GetTypeInfo().IsValueType ? Activator.CreateInstance(type) : null;
        }
    }
}


