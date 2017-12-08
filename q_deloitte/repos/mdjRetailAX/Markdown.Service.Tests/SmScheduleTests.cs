using System;
using Xunit;
using FluentAssertions;

using Markdown.Service.Models;

namespace Markdown.Service.Tests
{
    public class SmScheduleTests
    {
        [Fact]
        public void Expand_One_Markdown_One_Week()
        {
            var schedule = SmDenseSchedule.FromInteger(1, 10, 1);
            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.5M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var expected = new[]
            {
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 1, Prices = new decimal?[]{ 0.1M }, Weeks = new []{ 10 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 1, Prices = new decimal?[]{ 0.5M }, Weeks = new []{ 10 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 1, Prices = new decimal?[]{ 0.9M }, Weeks = new []{ 10 }}
            };

            var result = schedule.Expand(priceLadder);
            result.ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Expand_Two_Markdowns_Two_Weeks()
        {
            var schedule = SmDenseSchedule.FromInteger(Convert.ToInt32("11", 2), 10, 2);
            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.5M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var expected = new[]
            {
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new decimal?[]{ 0.1M, 0.5M }, Weeks = new []{ 10, 11 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new decimal?[]{ 0.5M, 0.9M }, Weeks = new []{ 10, 11 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new decimal?[]{ 0.1M, 0.9M }, Weeks = new []{ 10, 11 }}
            };

            var result = schedule.Expand(priceLadder);
            result.ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Expand_Two_Markdowns_On_First_And_Fourth_Week()
        {
            var schedule = SmDenseSchedule.FromInteger(Convert.ToInt32("1001", 2), 10, 4);
            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.5M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var expected = new[]
            {
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new decimal?[]{ 0.1M, 0.1M, 0.1M, 0.5M }, Weeks = new []{ 10, 11, 12, 13 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new decimal?[]{ 0.5M, 0.5M, 0.5M, 0.9M }, Weeks = new []{ 10, 11, 12, 13 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new decimal?[]{ 0.1M, 0.1M, 0.1M, 0.9M }, Weeks = new []{ 10, 11, 12, 13 }}
            };

            var result = schedule.Expand(priceLadder);
            result.ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Expand_Two_Markdowns_On_Second_And_Fourth_Week_With_Null_First()
        {
            var schedule = SmDenseSchedule.FromInteger(Convert.ToInt32("1010", 2), 10, 4);
            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.5M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var expected = new[]
            {
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new []{ (decimal?)null, 0.1M, 0.1M, 0.5M }, Weeks = new []{ 10, 11, 12, 13 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new []{ (decimal?)null, 0.5M, 0.5M, 0.9M }, Weeks = new []{ 10, 11, 12, 13 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 2, Prices = new []{ (decimal?)null, 0.1M, 0.1M, 0.9M }, Weeks = new []{ 10, 11, 12, 13 }}
            };

            var result = schedule.Expand(priceLadder);
            result.ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Expand_One_Markdown_Last_On_Fourth_Week_With_Three_Nulls()
        {
            var schedule = SmDenseSchedule.FromInteger(Convert.ToInt32("1000", 2), 10, 4);
            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.5M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var expected = new[]
            {
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 1, Prices = new []{ (decimal?)null, (decimal?)null, (decimal?)null, 0.1M }, Weeks = new []{ 10, 11, 12, 13 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 1,Prices = new []{ (decimal?)null, (decimal?)null, (decimal?)null, 0.5M }, Weeks = new []{ 10, 11, 12, 13 }},
                new SmSchedulePricePath { LadderType = SmPriceLadderType.Percent, MarkdownCount = 1,Prices = new []{ (decimal?)null, (decimal?)null, (decimal?)null, 0.9M }, Weeks = new []{ 10, 11, 12, 13 }}
            };

            var result = schedule.Expand(priceLadder);
            result.ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void No_Markdowns()
        {
            var schedule = SmDenseSchedule.NoMarkdowns(10, 13);
            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.5M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var expected = new []
            {
                new SmSchedulePricePath
                {
                    LadderType = SmPriceLadderType.Percent,
                    MarkdownCount = 0,
                    Prices = new decimal?[] {null, null, null, null},
                    Weeks = new[] {10, 11, 12, 13}
                }
            };

            var result = schedule.Expand(priceLadder);
            result.ShouldBeEquivalentTo(expected);
        }
    }
}
