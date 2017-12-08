using System;
using System.Collections.Generic;

namespace Markdown.WebApi.Models
{
    public class VmPage<T>
    {
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }
        public int TotalPageCount 
        { 
            get
            {
                if(PageSize >0)
                {
                    return (int)Math.Ceiling((double)TotalCount / PageSize);                                                   
                }

                return 1;
            } 
        }
        public IList<T> Items { get; set; }

    }
}

