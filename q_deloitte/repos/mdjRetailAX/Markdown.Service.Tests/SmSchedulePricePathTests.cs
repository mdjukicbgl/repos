using Xunit;
using FluentAssertions;
using Markdown.Service.Models;

namespace Markdown.Service.Tests
{
    public class SmSchedulePricePathTests
    {
        [Fact]
        public void Build_Eight_Weeks_Eight_Markdowns()
        {
            var weekMin = 11;
            var weekMax = 18; 
            var markdownWeeks = new [] { 11, 12, 13, 14, 15, 16, 17, 18 };
            var prices = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M };
            var priceLadderType = SmPriceLadderType.Percent;

            var expected = new SmSchedulePricePath
            {
                Weeks = new[] { 11, 12, 13, 14, 15, 16, 17, 18 },
                Prices = new decimal?[] {0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M},
                LadderType = SmPriceLadderType.Percent,
                MarkdownCount = 8
            };
         
            var result = SmSchedulePricePath.Build(weekMin, weekMax, markdownWeeks, priceLadderType, prices);
            result.ShouldBeEquivalentTo(expected);
        }

        [Fact]
        public void Build_Four_Weeks_Three_Markdowns()
        {
            var weekMin = 10;
            var weekMax = 13;
            var markdownWeeks = new [] { 11, 12, 13 };
            var prices = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M };
            var priceLadderType = SmPriceLadderType.Percent;

            var expected = new SmSchedulePricePath
            {
                Weeks = new[] { 10, 11, 12, 13 },
                Prices = new [] { (decimal?)null, 0.1M, 0.2M, 0.3M },
                LadderType = SmPriceLadderType.Percent,
                MarkdownCount = 3
            };

            var result = SmSchedulePricePath.Build(weekMin, weekMax, markdownWeeks, priceLadderType, prices);
            result.ShouldBeEquivalentTo(expected);
        }

        [Fact]
        public void Build_Has_Four_Weeks_One_Markdown_In_First_Week()
        {
            var weekMin = 11;
            var weekMax = 14;
            var markdownWeeks = new[] { 11 };
            var prices = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M };
            var priceLadderType = SmPriceLadderType.Percent;

            var expected = new SmSchedulePricePath
            {
                Weeks = new[] { 11, 12, 13, 14 },
                Prices = new decimal?[] { 0.1M, 0.1M, 0.1M, 0.1M },
                LadderType = SmPriceLadderType.Percent,
                MarkdownCount = 1
            };

            var result = SmSchedulePricePath.Build(weekMin, weekMax, markdownWeeks, priceLadderType, prices);
            result.ShouldBeEquivalentTo(expected);
        }

        [Fact]
        public void Build_Has_Four_Weeks_One_Markdown_In_Last_Week()
        {
            var weekMin = 11;
            var weekMax = 14;
            var markdownWeeks = new[] { 14 };
            var prices = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M };
            var priceLadderType = SmPriceLadderType.Percent;

            var expected = new SmSchedulePricePath
            {
                Weeks = new[] { 11, 12, 13, 14 },
                Prices = new [] { (decimal?)null, (decimal?)null, (decimal?)null, 0.1M },
                LadderType = SmPriceLadderType.Percent,
                MarkdownCount = 1
            };

            var result = SmSchedulePricePath.Build(weekMin, weekMax, markdownWeeks, priceLadderType, prices);
            result.ShouldBeEquivalentTo(expected);
        }
    }
}