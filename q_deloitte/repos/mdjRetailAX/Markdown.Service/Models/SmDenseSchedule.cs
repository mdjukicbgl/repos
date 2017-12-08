using System;
using System.Linq;
using System.Diagnostics;
using System.Collections.Generic;
using Markdown.Common.Extensions;

namespace Markdown.Service.Models
{
    [DebuggerDisplay("{DebuggerDisplay,nq}")]
    public struct SmDenseSchedule
    {
        public int ScheduleNumber { get; set; }
        public int WeekMin { get; set; }
        public int WeekMax { get; set; }
        public int MarkdownCount { get; set; }
        public int[] MarkdownWeeks { get; set; }
        public int WeekCount => WeekMax - WeekMin + 1;
        public SmWeekConstraint[] Constraints { get; set; }

        private string DebuggerDisplay => $"{ScheduleNumber} ({MarkdownCount}): {string.Join(", ", MarkdownWeeks)}";

        public static SmDenseSchedule FromInteger(int number, int firstWeek, int weekCount, List<SmWeekConstraint> allConstraints = null)
        {
            if (number < 0)
                throw new ArgumentOutOfRangeException(nameof(number));

            if (firstWeek < 0)
                throw new ArgumentOutOfRangeException(nameof(firstWeek));

            if (weekCount <= 0)
                throw new ArgumentOutOfRangeException(nameof(weekCount));

            // Identify markdown weeks, ie:
            // 010101 (right-to-left) = 1st, 3rd, 5th
            var weeks = new List<int>();
            for (var i = 0; i <= weekCount; i++)
                if ((number >> i & 1) == 1)
                    weeks.Add(firstWeek + i);

            var constraints =
                (allConstraints ?? new List<SmWeekConstraint>())
                .Where(x => weeks.Contains(x.Week))
                .ToArray();

            return new SmDenseSchedule
            {
                ScheduleNumber = number,
                MarkdownWeeks = weeks.ToArray(),
                WeekMin = firstWeek,
                WeekMax = weeks[weeks.Count - 1],
                MarkdownCount = weeks.Count,
                Constraints = constraints
            };
        }

        public static SmDenseSchedule NoMarkdowns(int firstWeek, int lastWeek)
        {
            if (firstWeek < 0)
                throw new ArgumentOutOfRangeException(nameof(firstWeek));

            if (lastWeek <= 0)
                throw new ArgumentOutOfRangeException(nameof(lastWeek));

            return new SmDenseSchedule
            {
                ScheduleNumber = 0,
                MarkdownWeeks = new List<int>().ToArray(),
                WeekMin = firstWeek,
                WeekMax = lastWeek,
                MarkdownCount = 0,
                Constraints = new SmWeekConstraint[0]
            };
        }

        public SmSchedulePricePath[] Expand(SmPriceLadder ladder)
        {
            var weekPrices = Optimise(this, ladder);
            return CrossProduct(MarkdownWeeks, WeekMin, WeekMax, ladder.Type, weekPrices);
        }

        public static List<Tuple<int, decimal>> Optimise(SmDenseSchedule schedule, SmPriceLadder priceLadder)
        {
            var weeks = schedule.MarkdownWeeks;
            var prices = priceLadder.Values;
            var width = weeks.Length;
            var height = prices.Length;
            var markdownCount = weeks.Length;
            var minDepths = weeks.Select(x => schedule.Constraints?.SingleOrDefault(y => y.Week == x)?.Min).ToArray();
            var maxDepths = weeks.Select(x => schedule.Constraints?.SingleOrDefault(y => y.Week == x)?.Max).ToArray();

            if (prices.Length < markdownCount)
                throw new ArgumentException("Insufficient number of price paths to satisfy markdown count requirement", nameof(prices));

            var weekDiscounts = new List<Tuple<int, decimal>>();
            var previousDiscounts = new List<decimal>();
            for (var w = 0; w < width; w++)
            {
                var week = weeks[w];
                var discounts = new List<decimal>();

                for (var p = 0; p < height; p++)
                {
                    var discount = prices[p];

                    var isLong = width - w >= markdownCount - p;
                    var isShort = height - p >= markdownCount - w;
                    var isLow = minDepths[w] != null && discount < minDepths[w];
                    var isHigh = maxDepths[w] != null && discount > maxDepths[w];
                    var isMarkdown = !previousDiscounts.Any() || discount > previousDiscounts[0];

                    if (isLong && isShort && !isHigh & !isLow && isMarkdown)
                    {
                        discounts.Add(discount);
                    }
                }

                weekDiscounts.AddRange(discounts.Select(x => Tuple.Create(week, x)));
                previousDiscounts = discounts;
            }

            return weekDiscounts;
        }

        public static SmSchedulePricePath[] CrossProduct(int[] weeks, int weekMin, int weekMax, SmPriceLadderType ladderType, List<Tuple<int, decimal>> weekPries)
        {
            var query = weekPries
                .GroupBy(x => x.Item1, (x, g) => g.Select(y => y.Item2).ToArray())
                .ToArray()
                .CartesianProduct()
                .Where(x => x.ToPairs().All(y => y.Item1 <= y.Item2))
                .Select(x => x.ToArray())
                .Where(x => x.Length == x.Distinct().Count())
                .Select(x => SmSchedulePricePath.Build(weekMin, weekMax, weeks, ladderType, x));

            return query.ToArray();
        }
    }
}

