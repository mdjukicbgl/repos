using System;
using System.Collections.Generic;

namespace Markdown.Common.Extensions
{
    public static class EnumerableToPairs
    {
        public static IEnumerable<Tuple<T, T>> ToPairs<T>(this IEnumerable<T> source)
        {
            int i = 0;
            T previous = default(T);
            foreach (T current in source)
            {
                if (i >= 1)
                    yield return Tuple.Create(previous, current);
                previous = current;
                i++;
            }
        }
    }
}