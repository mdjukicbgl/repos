﻿using System;
using System.Collections.Generic;
 using System.Linq;
 using System.Reflection;

namespace Markdown.Common.Filtering
{
    public interface IFilter
    {
        string Key { get; set; }
        object Value { get; set; }
        FilterOperator Op { get; set; }
        BinaryOperatorType OperatorType { get; set; }
        BinaryOperatorType NextOperatorType { get; set; }
        List<object> ValueList { get; set; }
    }

    public interface IFilterGroup
    {
        List<IFilter> FiltersGrouped { get; set; }
        BinaryOperatorType NextOperatorType { get; set; }
    }

    public class FilterGroup : IFilterGroup
    {
        public List<IFilter> FiltersGrouped { get; set; }
		public BinaryOperatorType NextOperatorType { get; set; }
    }

    public class Filter : IFilter
    {
        public string Key { get; set; }
        public object Value { get; set; }
        public FilterOperator Op { get; set; }
		public BinaryOperatorType NextOperatorType { get; set; }
        public BinaryOperatorType OperatorType { get; set; }
		public List<object> ValueList { get; set; }

        public static Filter Build<T>(FilterOperator op, string key, T value)
        {
            return new Filter
            {
                Op = op,
                Key = key,
                Value = value
            };
        }

		public static Filter Build<T>(FilterOperator op, string key, T value,
                                      BinaryOperatorType operatorType,
                                      BinaryOperatorType nextOperatorType )
		{
            return new Filter
			{
				Op = op,
				Key = key,
				Value = value,
				OperatorType = operatorType,
                NextOperatorType = nextOperatorType
			};
		}

		public static Filter Build<T>(FilterOperator op, string key, List<T> values)
		{
		    var filter = new Filter
		    {
		        Op = op,
		        Key = key,
		        ValueList = values.Cast<object>().ToList()
		    };

		    return filter;
		}
    }
}


