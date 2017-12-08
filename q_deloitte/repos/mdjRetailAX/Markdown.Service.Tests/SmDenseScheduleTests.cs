using System;
using System.Collections.Generic;
using Markdown.Service.Models;
using Markdown.Service.Tests.Helper;
using Xunit;

namespace Markdown.Service.Tests
{
    public class SmDenseScheduleTests
    {
        [Fact]
        public void Optimise_Identifies_All_Potential_Week_Price_Values()
        {
            char[,] expected =
            {
                { 'x', '_', '_', '_' },
                { 'x', 'x', '_', '_' },
                { 'x', 'x', 'x', '_' },
                { 'x', 'x', 'x', 'x' },
                { 'x', 'x', 'x', 'x' },
                { 'x', 'x', 'x', 'x' },
                { '_', 'x', 'x', 'x' },
                { '_', '_', 'x', 'x' },
                { '_', '_', '_', 'x' }
            };

            var priceLadder = new SmPriceLadder
            {
                Values = new [] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M },
                Type = SmPriceLadderType.Percent
            };
            var schedule = SmDenseSchedule.FromInteger(170, 1, 8);
            var result = SmDenseSchedule.Optimise(schedule, priceLadder);

            Simplify(priceLadder, schedule, result)
                .Should()
                .Equal(expected, (left, right) => left == right);
        }

        [Fact]
        public void Optimise_Constrains_To_Minimum_Discounts()
        {
            char[,] expected =
            {
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { 'x', '_', '_', '_' },
                { 'x', 'x', '_', '_' },
                { '_', 'x', 'x', '_' },
                { '_', '_', 'x', 'x' },
                { '_', '_', '_', 'x' }
            };

            var priceLadder = new SmPriceLadder
            {
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var schedule = SmDenseSchedule.FromInteger(170, 1, 8);
            schedule.Constraints = new[]
            {
                SmWeekConstraint.Minimum(2, 0.5M),
                SmWeekConstraint.Minimum(4, 0.6M),
                SmWeekConstraint.Minimum(6, 0.7M),
                SmWeekConstraint.Minimum(8, 0.8M)
            };

            var result = SmDenseSchedule.Optimise(schedule, priceLadder);

            Simplify(priceLadder, schedule, result)
                .Should()
                .Equal(expected, (left, right) => left == right);
        }

        [Fact]
        public void Optimise_Constrains_To_Fixed_Discounts()
        {
            char[,] expected =
            {
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { 'x', '_', '_', '_' },
                { '_', 'x', '_', '_' },
                { '_', '_', 'x', '_' },
                { '_', '_', '_', 'x' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' }
            };

            var priceLadder = new SmPriceLadder
            {
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M},
                Type = SmPriceLadderType.Percent
            };

            var schedule = SmDenseSchedule.FromInteger(170, 1, 8); 
            schedule.Constraints = new[]
            {
                SmWeekConstraint.Fixed(2, 0.3M),
                SmWeekConstraint.Fixed(4, 0.4M),
                SmWeekConstraint.Fixed(6, 0.5M),
                SmWeekConstraint.Fixed(8, 0.6M)
            };

            var result = SmDenseSchedule.Optimise(schedule, priceLadder);

            Simplify(priceLadder, schedule, result)
                .Should()
                .Equal(expected, (left, right) => left == right);
        }

        [Fact]
        public void Optimise_Constrains_To_Range_Discounts()
        {
            char[,] expected =
            {
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { 'x', '_', '_', '_' },
                { 'x', 'x', '_', '_' },
                { 'x', 'x', 'x', '_' },
                { '_', 'x', 'x', 'x' },
                { '_', '_', 'x', 'x' },
                { '_', '_', '_', 'x' },
                { '_', '_', '_', '_' }
            };

            var priceLadder = new SmPriceLadder
            {
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var schedule = SmDenseSchedule.FromInteger(170, 1, 8);
            schedule.Constraints = new[]
            {
                SmWeekConstraint.Range(2, 0.3M, 0.5M),
                SmWeekConstraint.Range(4, 0.4M, 0.6M),
                SmWeekConstraint.Range(6, 0.5M, 0.7M),
                SmWeekConstraint.Range(8, 0.6M, 0.8M)
            };

            var result = SmDenseSchedule.Optimise(schedule, priceLadder);

            Simplify(priceLadder, schedule, result)
                .Should()
                .Equal(expected, (left, right) => left == right);
        }

        [Fact]
        public void Optimise_Constrains_To_Maximum_Discounts()
        {
            char[,] expected =
            {
                { 'x', '_', '_', '_' },
                { 'x', 'x', '_', '_' },
                { '_', 'x', 'x', '_' },
                { '_', '_', 'x', 'x' },
                { '_', '_', '_', 'x' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' }
            };

            var priceLadder = new SmPriceLadder
            {
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var schedule = SmDenseSchedule.FromInteger(170, 1, 8);
            schedule.Constraints = new[]
            {
                SmWeekConstraint.Maximum(2, 0.2M),
                SmWeekConstraint.Maximum(4, 0.3M),
                SmWeekConstraint.Maximum(6, 0.4M),
                SmWeekConstraint.Maximum(8, 0.5M)
            };

            var result = SmDenseSchedule.Optimise(schedule, priceLadder);

            Simplify(priceLadder, schedule, result)
                .Should()
                .Equal(expected, (left, right) => left == right);
        }


        [Fact]
        public void Optimise_Constraints_Are_Always_Markdowns()
        {
            char[,] expected =
            {
                { '_', '_', '_', '_' },
                { '_', '_', '_', '_' },
                { 'x', '_', '_', '_' },
                { 'x', 'x', '_', '_' },
                { 'x', 'x', 'x', '_' },
                { '_', 'x', 'x', 'x' },
                { '_', 'x', 'x', 'x' },
                { '_', '_', '_', 'x' },
                { '_', '_', '_', 'x' }
            };

            var priceLadder = new SmPriceLadder
            {
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M },
                Type = SmPriceLadderType.Percent
            };

            var schedule = SmDenseSchedule.FromInteger(170, 1, 8);
            schedule.Constraints = new[]
            {
                SmWeekConstraint.Range(2, 0.3M, 0.5M),
                SmWeekConstraint.Range(6, 0.5M, 0.7M)
            };

            var result = SmDenseSchedule.Optimise(schedule, priceLadder);

            Simplify(priceLadder, schedule, result)
                .Should()
                .Equal(expected, (left, right) => left == right);
        }

        private static char[,] Simplify(SmPriceLadder priceLadder, SmDenseSchedule schedule, ICollection<Tuple<int, decimal>> test)
        {
            var result = new char[priceLadder.Values.Length, schedule.MarkdownWeeks.Length];
            for (var y = 0; y < priceLadder.Values.Length; y++)
            {
                for (var x = 0; x < schedule.MarkdownWeeks.Length; x++)
                {
                    result[y, x] = test.Contains(Tuple.Create(schedule.MarkdownWeeks[x], priceLadder.Values[y]))
                        ? 'x'
                        : '_';
                }
            }
            return result;
        }
    }
}