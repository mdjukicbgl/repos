using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Markdown.Common.Extensions
{
    public static class EnumerableCartesianProduct
    {
        public static IEnumerable<IEnumerable<T>> CartesianProduct<T>(this IEnumerable<IEnumerable<T>> sequences)
        {
            IEnumerable<IEnumerable<T>> e = new[] { Enumerable.Empty<T>() };
            return sequences.Aggregate(e, (acc, seq) => acc.SelectMany(accseq => seq, (accseq, x) => accseq.Concat(new[] { x })));
        }
    }
}