using System.Collections.Concurrent;
using System.Collections.Generic;

namespace Markdown.Common.Extensions
{
    public static class ConcurrentBagAddRange
    {
        public static void AddRange<T>(this ConcurrentBag<T> @this, IEnumerable<T> toAdd)
        {
            foreach (var element in toAdd)
            {
                @this.Add(element);
            }
        }
    }
}