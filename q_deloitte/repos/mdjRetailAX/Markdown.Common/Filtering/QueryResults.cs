using System;
using System.Collections.Generic;

namespace Markdown.Common.Filtering
{
    public class QueryResults<T>
    {
        public List<T> Items { get; set; } = new List<T>();
        public int PageIndex { get; set; } = 1;
        public int PageSize { get; set; } = 0;
        public int Total { get; set; } = 0;
    }
}
