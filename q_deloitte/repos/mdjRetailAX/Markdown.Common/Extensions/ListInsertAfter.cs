using System;
using System.Collections.Generic;
using System.Linq;

namespace Markdown.Common.Extensions
{
    public static class ListInsertAfter
    {
        public static bool InsertAfter<T>(this List<T> src, T insert, int max, Func<T, bool> insertAfter, bool skipOptimisation = false)
        {
            if (!src.Any())
            {
                src.Add(insert);
                return true;
            }

            // Meet predicate
            if (!skipOptimisation && !insertAfter(src[0]))
                return false;

            // Find first element where predicate
            // isn't satisified and insert before
            for (var i = 0; i < src.Count; i++)
            {
                if (!insertAfter(src[i]))
                {
                    src.Insert(i, insert);
                    break;
                }

                if (i == src.Count - 1)
                {
                    src.Insert(i + 1, insert);
                    break;
                }
            }

            if (src.Count > max)
                src.RemoveAt(0);

            return true;
        }
    }
}