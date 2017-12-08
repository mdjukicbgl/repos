using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FluentAssertions;
using FluentAssertions.Common;
using Markdown.Common.Statistics;
using Markdown.Data.Entity.Ephemeral;
using Markdown.Data.Repository.S3;
using Markdown.Service.Models;
using Microsoft.Extensions.Caching.Memory;
using Moq;
using Serilog;
using Xunit;
using Markdown.Common.Enums;

namespace Markdown.Service.Tests
{
    public class MarkdownServiceTests
    {
        public List<ElasticityHierarchy> GenerateElasticity(int stageMax, double step = 0.1)
        {
            var result = new List<ElasticityHierarchy>();
            for (var s = 0; s < stageMax; s++)
            {
                result.Add(new ElasticityHierarchy
                {
                    Stage = s,
                    Children = 0,
                    HierarchyId = 1,
                    HierarchyPath = "HierarchyPath",
                    HierarchyName = "HierarchyName",
                    PriceElasticity = (decimal) (1.0 - ((1 + s) * step)),
                });
            }
            return result;
        }

        public List<DecayHierarchy> GenerateDecay(int stageMax, int offsetMax, double step = 0.1)
        {
            var result = new List<DecayHierarchy>();
            for (var s = 0; s < stageMax; s++)
            {
                for (var o = 0; o < offsetMax; o++)
                {
                    result.Add(new DecayHierarchy
                    {
                        Stage = s,
                        StageOffset = o,
                        Children = 0,
                        HierarchyId = 1,
                        HierarchyPath = "HierarchyPath",
                        HierarchyName = "HierarchyName",
                        Decay = (decimal) (1.0 - ((1 + o) * step))
                    });
                }
            }
            return result;
        }

        [Fact]
        public void Calculate_Will_Return_Recommendations_With_CSP()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var clientId = 123;
            var modelId = 11;
            var revisionId = 0;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new [] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] {0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0

            };

            var scenario = new SmScenario
            {
                OrganisationId = clientId,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var scheduleService = new ScheduleService();
            var schedules = scheduleService.GetSchedules(new SmScheduleOptions
            {
                WeekMin = scenario.ScheduleWeekMin,
                WeekMax = scenario.ScheduleWeekMax,
                ExcludeConsecutiveWeeks = true
            });
            
            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var result = service.Calculate(scenario, modelId, revisionId, schedules, decayHierarchy, elasticityHierarchy, product);

            result.ClientId.IsSameOrEqualTo(clientId);
            result.ModelId.IsSameOrEqualTo(modelId);
            result.ScenarioId.IsSameOrEqualTo(scenario.ScenarioId);
            result.ProductId.IsSameOrEqualTo(product.ProductId);
            result.State.IsSameOrEqualTo(ProductState.Ok);

            result.Recommendations.Should().HaveCount(11);
            result.Recommendations.Select(x => x.RevisionId).ShouldAllBeEquivalentTo(revisionId);
            result.Recommendations.Should().ContainSingle(x => x.TotalMarkdownCount == 0).Which.Projections.Select(x => x.Discount).ShouldAllBeEquivalentTo(0);
        }

        [Fact]
        public void Calculate_Will_Return_Recommendations_Without_CSP_For_Revisions()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var clientId = 123;
            var modelId = 111;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var scenario = new SmScenario
            {
                OrganisationId = clientId,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var scheduleService = new ScheduleService();
            var schedules = scheduleService.GetSchedules(new SmScheduleOptions
            {
                WeekMin = scenario.ScheduleWeekMin,
                WeekMax = scenario.ScheduleWeekMax,
                ExcludeConsecutiveWeeks = true
            });

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var result = service.Calculate(scenario, modelId, revisionId, schedules, decayHierarchy, elasticityHierarchy, product);

            result.ClientId.IsSameOrEqualTo(clientId);
            result.ModelId.IsSameOrEqualTo(modelId);
            result.ScenarioId.IsSameOrEqualTo(scenario.ScenarioId);
            result.ProductId.IsSameOrEqualTo(product.ProductId);
            result.State.IsSameOrEqualTo(ProductState.Ok);

            result.Recommendations.Should().HaveCount(10);
            result.Recommendations.Select(x => x.RevisionId).ShouldAllBeEquivalentTo(revisionId);
            result.Recommendations.Should().NotContain(x => x.TotalMarkdownCount == 0 && x.Projections.Select(y => y.Discount).Distinct().Single() == 0);
        }

        [Fact]
        public void Calculate_Will_Return_Only_CSP_If_ProductHasExceededFlowlineThreshold()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var organisationId = 123;
            var modelId = 11;
            var revisionId = 0;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 1
            };

            var scenario = new SmScenario
            {
                OrganisationId = organisationId,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var scheduleService = new ScheduleService();
            var schedules = scheduleService.GetSchedules(new SmScheduleOptions
            {
                WeekMin = scenario.ScheduleWeekMin,
                WeekMax = scenario.ScheduleWeekMax,
                ExcludeConsecutiveWeeks = true
            });

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var result = service.Calculate(scenario, modelId, revisionId, schedules, decayHierarchy, elasticityHierarchy, product);

            result.ClientId.IsSameOrEqualTo(organisationId);
            result.ModelId.IsSameOrEqualTo(modelId);
            result.ScenarioId.IsSameOrEqualTo(scenario.ScenarioId);
            result.ProductId.IsSameOrEqualTo(product.ProductId);
            result.State.IsSameOrEqualTo(ProductState.Ok);

            result.Recommendations.Should().HaveCount(1);
            result.Recommendations.Select(x => x.RevisionId).ShouldAllBeEquivalentTo(revisionId);
        }

        public void CalculatePricePath_Will_Accumulate_Markdown_Count()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;
            var expected = new List<int> { 3, 3, 3, 4 };

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                OriginalSellingPrice = 100,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 2,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };
        
            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId], 
                elasticityHierarchy[product.HierarchyId], 
                product.PriceLadder, 
                schedule.ScheduleNumber,
                pricePaths
               );

            result.Should().BeTrue();
            calcRecommendation.TotalMarkdownCount.Should().Be(4);
            calcRecommendation.Projections.Select(x => x.AccumulatedMarkdownCount).ShouldBeEquivalentTo(expected, o => o.WithStrictOrdering());
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Markdown_Constraint_Pass()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;
            var expected = new List<MarkdownType> { MarkdownType.New, MarkdownType.Existing, MarkdownType.Existing, MarkdownType.Further };

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[]
                {
                    MarkdownType.Existing | MarkdownType.FullPrice | MarkdownType.New,
                    MarkdownType.Any,
                    MarkdownType.Any,
                    MarkdownType.Existing | MarkdownType.FullPrice | MarkdownType.Further
                },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };
            
            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);
         
            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeTrue();
            calcRecommendation.Projections.Select(x => x.MarkdownType).ShouldBeEquivalentTo(expected, o => o.WithStrictOrdering());
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Markdown_Constraint_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[]
                {
                    MarkdownType.Existing | MarkdownType.FullPrice | MarkdownType.Further,
                    MarkdownType.Any,
                    MarkdownType.Any,
                    MarkdownType.Existing | MarkdownType.FullPrice | MarkdownType.Further
                },
                MinimumRelativePercentagePriceChange = new[] {0M, 0M, 0M, 0M},
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Relative_Price_Change()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;
            var expected = new List<decimal> { 0.1M, 0.1M, 0.1M, 0.2M };

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice)
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeTrue();
            calcRecommendation.Projections.Select(x => x.Discount).ShouldBeEquivalentTo(expected, o => o.WithStrictOrdering());
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Relative_Price_Change_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0.5M, 0.5M, 0.5M, 0.5M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
            calcProduct.MinimumRelativePercentagePriceChangeNotMetCount.Should().Be(1);
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Absolute_Price_Change()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;
            var expected = new List<decimal> { 0.1M, 0.1M, 0.1M, 0.2M };

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var cache = new MemoryCache(new MemoryCacheOptions());
        
            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeTrue();
            calcRecommendation.Projections.Select(x => x.Discount).ShouldBeEquivalentTo(expected, o => o.WithStrictOrdering());
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Absolute_Price_Change_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumAbsolutePriceChange = 20,
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
            calcProduct.MinimumAbsolutePriceChangeNotMetCount.Should().Be(1);
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Discounts()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;
            var expected = new List<decimal> { 0.1M, 0.1M, 0.1M, 0.2M };

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0.2M, 0.2M, 0.2M, 0.2M },
                MinDiscountsNew = new[] { 0.1M, 0.1M, 0.1M, 0.1M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeTrue();
            calcRecommendation.Projections.Select(x => x.Discount).ShouldBeEquivalentTo(expected, o => o.WithStrictOrdering());
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Discounts_New_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumAbsolutePriceChange = 0,
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0.8M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
            calcProduct.DiscountPercentageOutsideAllowedRangeCount.Should().Be(1);
        }

        [Fact]
        public void CalculatePricePath_Will_Apply_Minimum_Discounts_Further_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumAbsolutePriceChange = 0,
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0.8M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
            calcProduct.DiscountPercentageOutsideAllowedRangeCount.Should().Be(1);
        }

        public void CalculatePricePath_Will_Apply_Maximum_Discounts_Further_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumAbsolutePriceChange = 0,
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 0.5M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
            calcProduct.DiscountPercentageOutsideAllowedRangeCount.Should().Be(1);
        }

        public void CalculatePricePath_Will_Apply_Maximum_Discounts_New_Fail()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var modelId = 100;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumAbsolutePriceChange = 0,
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 0.5M },
                CurrentMarkdownType = MarkdownType.FullPrice
            };

            var scenario = new SmScenario
            {
                OrganisationId = 11,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var schedule = SmDenseSchedule.FromInteger(9, scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePaths = SmSchedulePricePath.Build(schedule.WeekMin, schedule.WeekMax, schedule.MarkdownWeeks,
                product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { schedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                schedule.ScheduleNumber,
                pricePaths
            );

            result.Should().BeFalse();
            calcProduct.DiscountPercentageOutsideAllowedRangeCount.Should().Be(1);
        }

        [Fact]
        public void CalculatePricePath_Will_Calculate_MarkdownCost()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

            var clientId = 123;
            var modelId = 111;
            var revisionId = 42;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 20,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 2000,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var scenario = new SmScenario
            {
                OrganisationId = clientId,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var scheduleService = new ScheduleService();
            var schedules = scheduleService.GetSchedules(new SmScheduleOptions
            {
                WeekMin = scenario.ScheduleWeekMin,
                WeekMax = scenario.ScheduleWeekMax,
                ExcludeConsecutiveWeeks = true
            });

            // A single schedule has been selected to test. This schedule has a markdown in week 1 and no further markdowns.
            var schedule = new List<SmDenseSchedule>(1)
            {
                schedules.FirstOrDefault(x => x.ScheduleNumber == 2)
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var result = service.Calculate(scenario, modelId, revisionId, schedule, decayHierarchy, elasticityHierarchy, product);
            result.State.IsSameOrEqualTo(ProductState.Ok);

            // The recommendation with the markdown is selected and not the default 0 markdown recommendation.
            var recommendation = result.Recommendations.Single(x => x.Rank == 1);

            // The projection for week 1 (the week with the markdown) is selected.
            var projection = recommendation.Projections.FirstOrDefault(x => x.Week == 11);

            // The exepected markdown cost is derived.
            var expectedMarkdownCost = (result.CurrentSellingPrice - projection.Price) * projection.Stock;

            projection.MarkdownCost.Should().Be(expectedMarkdownCost);
        }

        [Fact]
        public void CalculatePricePath_Will_Process_CSP_Revision()
        {
            var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
            var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));
    
            var clientId = 123;
            var modelId = 111;
            var revisionId = 0;

            var priceLadder = new SmProductPriceLadder
            {
                PriceLadderId = 123,
                Type = SmPriceLadderType.Percent,
                Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
            };

            var product = new SmProduct
            {
                CurrentCostPrice = 80,
                CurrentSellingPrice = 100,
                CurrentCover = 100,
                CurrentMarkdownCount = 0,
                CurrentSalesQuantity = 100,
                CurrentStock = 100,
                HierarchyId = 1,
                HierarchyName = "HierarchyName",
                HierarchyPath = "HierarchyPath",
                PriceLadder = priceLadder,
                Name = "Name",
                OriginalSellingPrice = 100,
                ProductId = 1,
                ProductScheduleMask = null,
                SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
                MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
                MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

            var depth = new SmDepth
            {
                MarkdownDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
                DiscountLadderDepth = 1 - (product.CurrentSellingPrice / product.OriginalSellingPrice),
            };

            var scenario = new SmScenario
            {
                OrganisationId = clientId,
                ScenarioId = 22,
                ScenarioName = "ScenarioName",
                ScheduleMask = 0,
                PriceFloor = null,
                ScheduleWeekMin = 10,
                ScheduleWeekMax = 13,
                StageMax = 4,
                StageOffsetMax = 4,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

            var cache = new MemoryCache(new MemoryCacheOptions());

            var logger = new Mock<ILogger>();
            var s3Repository = new Mock<IS3Repository>();
            var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

            var noChangeSchedule = SmDenseSchedule.NoMarkdowns(scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
            var pricePath = SmSchedulePricePath.Build(noChangeSchedule.WeekMin, noChangeSchedule.WeekMax, noChangeSchedule.MarkdownWeeks, product.PriceLadder.Type, product.PriceLadder.Values);

            var calcProduct = new SmCalcProduct(scenario, modelId, product, new List<SmDenseSchedule> { noChangeSchedule }, depth);

            var calcRecommendation = default(SmCalcRecommendation);
            var result = service.CalculatePricePath(
                ref calcProduct,
                ref calcRecommendation,
                scenario,
                modelId,
                revisionId,
                decayHierarchy[product.HierarchyId],
                elasticityHierarchy[product.HierarchyId],
                product.PriceLadder,
                noChangeSchedule.ScheduleNumber,
                pricePath
            );

            result.Should().BeTrue();
            calcRecommendation.Projections.Select(x => x.Discount).ShouldAllBeEquivalentTo(0);
            calcRecommendation.Projections.Select(x => x.MarkdownCost).ShouldAllBeEquivalentTo(0);
        }

        [Fact]
        public async Task Save_Will_Call_Repository()
        {
            var path = new SmS3Path
            {
                BucketName = "BucketName",
                Key = "Key"
            };

            var products = new List<SmCalcProduct>();

            var logger = new Mock<ILogger>();
            var cache = new Mock<IMemoryCache>();

            var s3Repository = new Mock<IS3Repository>();
            s3Repository
                .Setup(x => x.WriteRecords(path, products))
                .Returns(Task.CompletedTask);

            var service = new MarkdownService(logger.Object, cache.Object, s3Repository.Object);
            await service.Save(products, path);

            s3Repository.VerifyAll();
        }

		[Fact]
		public void EstimatedProfit_Equals_TotalRevenue_Minue_TotalCost()
		{
			var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
			var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

			var clientId = 123;
			var modelId = 111;
			var revisionId = 42;

			var priceLadder = new SmProductPriceLadder
			{
				PriceLadderId = 123,
				Type = SmPriceLadderType.Percent,
				Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
			};

			var product = new SmProduct
			{
				CurrentCostPrice = 80,
				CurrentSellingPrice = 100,
				CurrentCover = 20,
				CurrentMarkdownCount = 0,
				CurrentSalesQuantity = 100,
				CurrentStock = 2000,
				HierarchyId = 1,
				HierarchyName = "HierarchyName",
				HierarchyPath = "HierarchyPath",
				PriceLadder = priceLadder,
				Name = "Name",
				OriginalSellingPrice = 100,
				ProductId = 1,
				ProductScheduleMask = null,
				SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
			    MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
			    MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

			var scenario = new SmScenario
			{
				OrganisationId = clientId,
				ScenarioId = 22,
				ScenarioName = "ScenarioName",
				ScheduleMask = 0,
				PriceFloor = null,
				ScheduleWeekMin = 10,
				ScheduleWeekMax = 13,
				StageMax = 4,
				StageOffsetMax = 4,
				ScheduleStageMin = 1,
				ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

			var scheduleService = new ScheduleService();
			var schedules = scheduleService.GetSchedules(new SmScheduleOptions
			{
				WeekMin = scenario.ScheduleWeekMin,
				WeekMax = scenario.ScheduleWeekMax,
				ExcludeConsecutiveWeeks = true
			});

			// A single schedule has been selected to test. This schedule has a markdown in week 1 and no further markdowns.
			var schedule = new List<SmDenseSchedule>(1)
			{
				schedules.FirstOrDefault(x => x.ScheduleNumber == 2)
			};

			var cache = new MemoryCache(new MemoryCacheOptions());

			var logger = new Mock<ILogger>();
			var stats = new Mock<ICalculationStatistics>();
			var s3Repository = new Mock<IS3Repository>();
			var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

			var result = service.Calculate(scenario, modelId, revisionId, schedule, decayHierarchy, elasticityHierarchy, product);
		    result.State.IsSameOrEqualTo(ProductState.Ok);

            // The recommendation with the markdown is selected and not the default 0 markdown recommendation.
            var recommendation = result.Recommendations.Single(x => x.Rank == 1);

			// The exepected estimatedProfit is derived.
			var expectedEstimatedProfit = (recommendation.TotalRevenue - recommendation.TotalCost);

			recommendation.EstimatedProfit.Should().Be(expectedEstimatedProfit);
		}

		[Fact]
		public void StockValue_Equals_CurrentSellingPrice_Times_CurrentStock()
		{
			var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
			var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

			var clientId = 123;
			var modelId = 111;
			var revisionId = 42;

			var priceLadder = new SmProductPriceLadder
			{
				PriceLadderId = 123,
				Type = SmPriceLadderType.Percent,
				Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
			};

			var product = new SmProduct
			{
				CurrentCostPrice = 80,
				CurrentSellingPrice = 100,
				CurrentCover = 20,
				CurrentMarkdownCount = 0,
				CurrentSalesQuantity = 100,
				CurrentStock = 2000,
				HierarchyId = 1,
				HierarchyName = "HierarchyName",
				HierarchyPath = "HierarchyPath",
				PriceLadder = priceLadder,
				Name = "Name",
				OriginalSellingPrice = 100,
				ProductId = 1,
				ProductScheduleMask = null,
				SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
			    MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
			    MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

			var scenario = new SmScenario
			{
				OrganisationId = clientId,
				ScenarioId = 22,
				ScenarioName = "ScenarioName",
				ScheduleMask = 0,
				PriceFloor = null,
				ScheduleWeekMin = 10,
				ScheduleWeekMax = 13,
				StageMax = 4,
				StageOffsetMax = 4,
				ScheduleStageMin = 1,
				ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

			var scheduleService = new ScheduleService();
			var schedules = scheduleService.GetSchedules(new SmScheduleOptions
			{
				WeekMin = scenario.ScheduleWeekMin,
				WeekMax = scenario.ScheduleWeekMax,
				ExcludeConsecutiveWeeks = true
			});

			// A single schedule has been selected to test. This schedule has a markdown in week 1 and no further markdowns.
			var schedule = new List<SmDenseSchedule>(1)
			{
				schedules.FirstOrDefault(x => x.ScheduleNumber == 2)
			};

			var cache = new MemoryCache(new MemoryCacheOptions());

			var logger = new Mock<ILogger>();
			var stats = new Mock<ICalculationStatistics>();
			var s3Repository = new Mock<IS3Repository>();
			var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

			var result = service.Calculate(scenario, modelId, revisionId, schedule, decayHierarchy, elasticityHierarchy, product);
		    result.State.IsSameOrEqualTo(ProductState.Ok);

            // The recommendation with the markdown is selected and not the default 0 markdown recommendation.
            var recommendation = result.Recommendations.Single(x => x.Rank == 1);

			// The exepected expectedStockValue is derived.
			var expectedStockValue = (result.CurrentSellingPrice * product.CurrentStock);

            recommendation.StockValue.Should().Be(expectedStockValue);
		}

		[Fact]
		public void FinalDiscount_Equals_LastWeekOfProjections_Discount()
		{
			var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
			var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

			var clientId = 123;
			var modelId = 111;
			var revisionId = 42;

			var priceLadder = new SmProductPriceLadder
			{
				PriceLadderId = 123,
				Type = SmPriceLadderType.Percent,
				Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
			};

			var product = new SmProduct
			{
				CurrentCostPrice = 80,
				CurrentSellingPrice = 100,
				CurrentCover = 20,
				CurrentMarkdownCount = 0,
				CurrentSalesQuantity = 100,
				CurrentStock = 2000,
				HierarchyId = 1,
				HierarchyName = "HierarchyName",
				HierarchyPath = "HierarchyPath",
				PriceLadder = priceLadder,
				Name = "Name",
				OriginalSellingPrice = 100,
				ProductId = 1,
				ProductScheduleMask = null,
			    SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
			    MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
			    MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

			var scenario = new SmScenario
			{
				OrganisationId = clientId,
				ScenarioId = 22,
				ScenarioName = "ScenarioName",
				ScheduleMask = 0,
				PriceFloor = null,
				ScheduleWeekMin = 10,
				ScheduleWeekMax = 13,
				StageMax = 4,
				StageOffsetMax = 4,
				ScheduleStageMin = 1,
				ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

			var scheduleService = new ScheduleService();
			var schedules = scheduleService.GetSchedules(new SmScheduleOptions
			{
				WeekMin = scenario.ScheduleWeekMin,
				WeekMax = scenario.ScheduleWeekMax,
				ExcludeConsecutiveWeeks = true
			});

			// A single schedule has been selected to test. This schedule has a markdown in week 1 and no further markdowns.
			var schedule = new List<SmDenseSchedule>(1)
			{
				schedules.FirstOrDefault(x => x.ScheduleNumber == 2)
			};

			var cache = new MemoryCache(new MemoryCacheOptions());

			var logger = new Mock<ILogger>();
			var stats = new Mock<ICalculationStatistics>();
			var s3Repository = new Mock<IS3Repository>();
			var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

			var result = service.Calculate(scenario, modelId, revisionId, schedule, decayHierarchy, elasticityHierarchy, product);
		    result.State.IsSameOrEqualTo(ProductState.Ok);

            // The recommendation with the markdown is selected and not the default 0 markdown recommendation.
            var recommendation = result.Recommendations.Single(x => x.Rank == 1);

			// The exepected expectedFinalDiscount is derived.
			var expectedFinalDiscount = recommendation.Projections.Last().Discount;

            recommendation.FinalDiscount.Should().Be(expectedFinalDiscount);
		}

		[Fact]
		public void EstimatedSales_Equals_SumOfQuantities_ForEachWeek()
		{
			var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
			var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

			var clientId = 123;
			var modelId = 111;
			var revisionId = 42;

			var priceLadder = new SmProductPriceLadder
			{
				PriceLadderId = 123,
				Type = SmPriceLadderType.Percent,
				Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
			};

			var product = new SmProduct
			{
				CurrentCostPrice = 80,
				CurrentSellingPrice = 100,
				CurrentCover = 20,
				CurrentMarkdownCount = 0,
				CurrentSalesQuantity = 100,
				CurrentStock = 2000,
				HierarchyId = 1,
				HierarchyName = "HierarchyName",
				HierarchyPath = "HierarchyPath",
				PriceLadder = priceLadder,
				Name = "Name",
				OriginalSellingPrice = 100,
				ProductId = 1,
				ProductScheduleMask = null,
				SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
			    MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
			    MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

			var scenario = new SmScenario
			{
				OrganisationId = clientId,
				ScenarioId = 22,
				ScenarioName = "ScenarioName",
				ScheduleMask = 0,
				PriceFloor = null,
				ScheduleWeekMin = 10,
				ScheduleWeekMax = 13,
				StageMax = 4,
				StageOffsetMax = 4,
				ScheduleStageMin = 1,
				ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

			var scheduleService = new ScheduleService();
			var schedules = scheduleService.GetSchedules(new SmScheduleOptions
			{
				WeekMin = scenario.ScheduleWeekMin,
				WeekMax = scenario.ScheduleWeekMax,
				ExcludeConsecutiveWeeks = true
			});

			// A single schedule has been selected to test. This schedule has a markdown in week 1 and no further markdowns.
			var schedule = new List<SmDenseSchedule>(1)
			{
				schedules.FirstOrDefault(x => x.ScheduleNumber == 2)
			};

			var cache = new MemoryCache(new MemoryCacheOptions());

			var logger = new Mock<ILogger>();
			var stats = new Mock<ICalculationStatistics>();
			var s3Repository = new Mock<IS3Repository>();
			var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

			var result = service.Calculate(scenario, modelId, revisionId, schedule, decayHierarchy, elasticityHierarchy, product);
		    result.State.IsSameOrEqualTo(ProductState.Ok);

            // The recommendation with the markdown is selected and not the default 0 markdown recommendation.
            var recommendation = result.Recommendations.Single(x => x.Rank == 1);

			// The exepected expectedEstimatedSales is derived.
			var expectedEstimatedSales = 0;
            recommendation.Projections.ForEach(x=>expectedEstimatedSales+=x.Quantity);
               
            recommendation.EstimatedSales.Should().Be(expectedEstimatedSales);
		}

		[Fact]
		public void TotalCost_Equals_CurrentCostPrice_Times_Quantity_ForEachWeek()
		{
			var elasticityHierarchy = SmElasticityHierarchy.Build(GenerateElasticity(4));
			var decayHierarchy = SmDecayHierarchy.Build(GenerateDecay(4, 4));

			var clientId = 123;
			var modelId = 111;
			var revisionId = 42;

			var priceLadder = new SmProductPriceLadder
			{
				PriceLadderId = 123,
				Type = SmPriceLadderType.Percent,
				Values = new[] { 0.1M, 0.2M, 0.3M, 0.4M, 0.5M, 0.6M, 0.7M, 0.8M, 0.9M }
			};

			var product = new SmProduct
			{
				CurrentCostPrice = 80,
				CurrentSellingPrice = 100,
				CurrentCover = 20,
				CurrentMarkdownCount = 0,
				CurrentSalesQuantity = 100,
				CurrentStock = 2000,
				HierarchyId = 1,
				HierarchyName = "HierarchyName",
				HierarchyPath = "HierarchyPath",
				PriceLadder = priceLadder,
				Name = "Name",
				OriginalSellingPrice = 100,
				ProductId = 1,
				ProductScheduleMask = null,
				SellThrough = 100,
                SalesFlexFactor = new[] { 1.0M, 1.0M, 1.6M, 1.0M, 0.8M, 1.1M, 1.0M, 1.0M },
			    MarkdownTypeConstraint = new[] { MarkdownType.Any, MarkdownType.Any, MarkdownType.Any, MarkdownType.Any },
			    MinimumRelativePercentagePriceChange = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsFurther = new[] { 0M, 0M, 0M, 0M },
                MinDiscountsNew = new[] { 0M, 0M, 0M, 0M },
                MaxDiscountsFurther = new[] { 1M, 1M, 1M, 1M },
                MaxDiscountsNew = new[] { 1M, 1M, 1M, 1M },
                CurrentMarkdownType = MarkdownType.FullPrice,
                ProductHasExceededFlowlineThreshold = 0
            };

			var scenario = new SmScenario
			{
				OrganisationId = clientId,
				ScenarioId = 22,
				ScenarioName = "ScenarioName",
				ScheduleMask = 0,
				PriceFloor = null,
				ScheduleWeekMin = 10,
				ScheduleWeekMax = 13,
				StageMax = 4,
				StageOffsetMax = 4,
				ScheduleStageMin = 1,
				ScheduleStageMax = 4,
                DefaultMarkdownType = 255
            };

			var scheduleService = new ScheduleService();
			var schedules = scheduleService.GetSchedules(new SmScheduleOptions
			{
				WeekMin = scenario.ScheduleWeekMin,
				WeekMax = scenario.ScheduleWeekMax,
				ExcludeConsecutiveWeeks = true
			});

			// A single schedule has been selected to test. This schedule has a markdown in week 1 and no further markdowns.
			var schedule = new List<SmDenseSchedule>(1)
			{
				schedules.FirstOrDefault(x => x.ScheduleNumber == 2)
			};

			var cache = new MemoryCache(new MemoryCacheOptions());

			var logger = new Mock<ILogger>();
			var stats = new Mock<ICalculationStatistics>();
			var s3Repository = new Mock<IS3Repository>();
			var service = new MarkdownService(logger.Object, cache, s3Repository.Object);

			var result = service.Calculate(scenario, modelId, revisionId, schedule, decayHierarchy, elasticityHierarchy, product);
		    result.State.IsSameOrEqualTo(ProductState.Ok);

            // The recommendation with the markdown is selected and not the default 0 markdown recommendation.
            var recommendation = result.Recommendations.Single(x => x.Rank == 1);

			// The exepected expectedEstimatedSales is derived.
		    var expectedTotalCost = recommendation.Projections.Sum(x => x.Quantity * product.CurrentCostPrice);

			recommendation.TotalCost.Should().Be(expectedTotalCost);
		}
    }
}