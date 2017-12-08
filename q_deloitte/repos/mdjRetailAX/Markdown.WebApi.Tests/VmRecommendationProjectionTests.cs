using System;
using System.Collections.Generic;
using System.Linq;
using Xunit;
using FluentAssertions;
using Markdown.Data.Entity.App;
using Markdown.Service.Models;
using Markdown.WebApi.Models;

namespace Markdown.WebApi.Tests
{
    public class VmRecommendationProjectionTests
    {
        [Fact]
        public void RecommendationProjection_Correctly_Identifies_Markdowns_From_Schedule_Mask()
        {
            var expected = new List<int> {1, 2, 3, 4, 6, 7, 8};

            // No markdown in week 5
            var scheduleMask = Convert.ToInt32("11101111", 2);

            // 5 markdowns, starting with CSP
            var scheduleId = Convert.ToInt32("10101110", 2);

            var recommendation = new SmRecommendationSummary
            {
                ScheduleId = scheduleId,
                ScheduleMask = scheduleMask
            };

            var projections = new List<SmRecommendationProjectionSummary>
            {
                new SmRecommendationProjectionSummary { Week = 1, Discount = 0 },
                new SmRecommendationProjectionSummary { Week = 2, Discount = 0.1M },
                new SmRecommendationProjectionSummary { Week = 3, Discount = 0.2M },
                new SmRecommendationProjectionSummary { Week = 4, Discount = 0.3M },
                new SmRecommendationProjectionSummary { Week = 5, Discount = 0.3M },
                new SmRecommendationProjectionSummary { Week = 6, Discount = 0.4M },
                new SmRecommendationProjectionSummary { Week = 7, Discount = 0.4M },
                new SmRecommendationProjectionSummary { Week = 8, Discount = 0.5M },
            };

            var result = VmRecommendationProjection.Build(recommendation, projections);

            result
                .Where(x => x.IsMarkdown)
                .Select(x => x.Week)
                .ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void RecommendationProjection_Correctly_Identifies_CSP_From_Schedule_Id()
        {
            var expected = new List<int> { 1 };

            // No markdown in week 5
            var scheduleMask = Convert.ToInt32("11101111", 2);

            // 5 markdowns, starting with CSP
            var scheduleId = Convert.ToInt32("10101110", 2);

            var recommendation = new SmRecommendationSummary
            {
                ScheduleId = scheduleId,
                ScheduleMask = scheduleMask
            };

            var projections = new List<SmRecommendationProjectionSummary>
            {
                new SmRecommendationProjectionSummary { Week = 1, Discount = 0 },
                new SmRecommendationProjectionSummary { Week = 2, Discount = 0.1M },
                new SmRecommendationProjectionSummary { Week = 3, Discount = 0.2M },
                new SmRecommendationProjectionSummary { Week = 4, Discount = 0.3M },
                new SmRecommendationProjectionSummary { Week = 5, Discount = 0.3M },
                new SmRecommendationProjectionSummary { Week = 6, Discount = 0.4M },
                new SmRecommendationProjectionSummary { Week = 7, Discount = 0.4M },
                new SmRecommendationProjectionSummary { Week = 8, Discount = 0.5M },
            };

            var result = VmRecommendationProjection.Build(recommendation, projections);

            result
                .Where(x => x.IsCsp)
                .Select(x => x.Week)
                .ShouldAllBeEquivalentTo(expected);
        }
    }
}