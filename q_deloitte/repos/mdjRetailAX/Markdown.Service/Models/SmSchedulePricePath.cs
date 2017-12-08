using System.Diagnostics;
using System.Linq;

namespace Markdown.Service.Models
{
    [DebuggerDisplay("{DebuggerDisplay,nq}")]
    public struct SmSchedulePricePath
    {
        public int[] Weeks { get; set; }
        public decimal?[] Prices { get; set; }
        public int MarkdownCount { get; set; }
        public SmPriceLadderType LadderType { get; set; }

        private string DebuggerDisplay => $"{MarkdownCount}: {string.Join(", ", Prices)}";

        public static SmSchedulePricePath Build(int weekMin, int weekMax, int[] markdownWeeks, SmPriceLadderType ladderType, decimal[] prices)
        {
            var weekCount = weekMax - weekMin + 1;
            if (markdownWeeks.Length == 0)
            {
                return new SmSchedulePricePath
                {
                    Prices = Enumerable.Repeat((decimal?)null, weekCount).ToArray(),
                    Weeks = Enumerable.Range(weekMin, weekCount).ToArray(),
                    MarkdownCount = markdownWeeks.Length,
                    LadderType = ladderType
                };
            }
         
            var result = new decimal?[weekCount];
            var pricePathIndex = -1;
            var weekNextMarkdown = markdownWeeks[0];
            var weekNextMarkdownIndex = 0;

            for (var i = 0; i < weekCount; i++)
            {
                var week = weekMin + i;
                if (weekNextMarkdownIndex == 0 && week < weekNextMarkdown)
                {
                    result[i] = null;
                    continue;
                }

                if (week == weekNextMarkdown)
                {
                    if (prices.Length - 1 >= pricePathIndex + 1)
                        pricePathIndex++;

                    if (markdownWeeks.Length - 1 >= weekNextMarkdownIndex + 1)
                    {
                        weekNextMarkdownIndex++;
                        weekNextMarkdown = markdownWeeks[weekNextMarkdownIndex];
                    }
                }

                result[i] = prices[pricePathIndex];
            }

            return new SmSchedulePricePath
            {
                Prices = result,
                Weeks = Enumerable.Range(weekMin, weekCount).ToArray(),
                MarkdownCount = markdownWeeks.Length,
                LadderType = ladderType
            };
        }
    }
}