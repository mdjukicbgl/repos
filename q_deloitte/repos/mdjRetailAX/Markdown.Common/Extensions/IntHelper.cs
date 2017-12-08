using System.Collections.Generic;
using System.Linq;

namespace Markdown.Common.Extensions
{
    public static class IntHelper
    {
        public static IEnumerable<int> GetBitIndexes(this int value)
        {
            if (value == 0)
                return Enumerable.Empty<int>();

            return Enumerable
                .Range(0, 32)
                .Where(x => (value & (1 << x)) != 0);
        }

        public static int? GetLeastSignficantBitIndex(this int value)
        {
            if (value == 0)
                return null;

            return Enumerable
                .Range(0, 32)
                .FirstOrDefault(x => (value & (1 << x)) != 0);
        }

        public static int? GetMostSignficantBitIndex(this int value)
        {
            if (value == 0)
                return null;

            return Enumerable
                .Range(0, 32)
                .Reverse()
                .FirstOrDefault(x => (value & (1 << x)) != 0);
        }
    }
}