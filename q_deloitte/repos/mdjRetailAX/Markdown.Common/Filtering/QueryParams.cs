using System;
using System.Collections.Generic;

namespace Markdown.Common.Filtering
{
    public class QueryParams
    {
        public List<IFilter> Filters { get; set; } = new List<IFilter>();
        public List<ISort> Sorts { get; set; } = new List<ISort>();
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
    }
}
