﻿using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.Extensions.Caching.Memory;

using Serilog;

using Markdown.Common.Enums;
using Markdown.Common.Extensions;
using Markdown.Data.Repository.S3;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IMarkdownService
    {
        SmCalcProduct Calculate(
            SmScenario scenario,
            int modelId,
            int revisionId,
            List<SmDenseSchedule> schedules,
            Dictionary<int, SmDecayHierarchy> decayHierarchies,
            Dictionary<int, SmElasticityHierarchy> elasticityHierarchies,
            SmProduct product,
            List<decimal> revisedDiscounts = null,
            CancellationToken cancellationToken = default(CancellationToken));

        bool CalculatePricePath(
            ref SmCalcProduct result,
            ref SmCalcRecommendation recommendation,
            SmScenario scenario,
            int modelId,
            int revisionId,
            SmDecayHierarchy decayHierarchy,
            SmElasticityHierarchy elasticityHierarchy,
            SmProductPriceLadder priceLadder,
            int scheduleId,
            SmSchedulePricePath schedulePricePath);

        Task Save(List<SmCalcProduct> results, SmS3Path s3Path);
    }

    public class MarkdownService : IMarkdownService
    {
        private readonly ILogger _logger;
        private readonly IS3Repository _s3Repository;
        private readonly IMemoryCache _ladderPathCache;

        public MarkdownService(ILogger logger, IMemoryCache cache, IS3Repository s3Repository)
        {
            _logger = logger;
            _ladderPathCache = cache;
            _s3Repository = s3Repository;
        }

        public SmCalcProduct Calculate(
            SmScenario scenario,
            int modelId,
            int revisionId,
            List<SmDenseSchedule> schedules,
            Dictionary<int, SmDecayHierarchy> decayHierarchies,
            Dictionary<int, SmElasticityHierarchy> elasticityHierarchies,
            SmProduct product,
            List<decimal> revisedDiscounts = null,
            CancellationToken cancellationToken = default(CancellationToken))
        {
            // Calculate the current markdown depth and ladder depth
            var depth = GetDiscountLadderDepth(product);

            var result = new SmCalcProduct(scenario, modelId, product, schedules, depth);

            // Return OK if there are no schedules for this product
            if (!schedules.Any())
            {
                _logger.Warning("No schedules for {ProductId}", product.ProductId);
                return result.Ok(ProductState.NoSchedules);
            }

            // Return Fatal recommendation for bad CSPs
            if (product.CurrentSellingPrice <= 0)
            {
                _logger.Warning("Product {ProductId} CSP is <= 0", product.ProductId);
                return result.Fatal(ProductState.InvalidCsp);
            }
            
            // Return Fatal if we can't resolve the decay hierarchy
            if (!decayHierarchies.TryGetValue(product.HierarchyId, out SmDecayHierarchy decayHierarchy))
            {
                _logger.Warning("Can't find Decay Hierarchy by HierarchyId {HierarchyId} for Product {ProductId}", product.HierarchyId, product.ProductId);
                return result.Fatal(ProductState.InvalidDecayHierarchy);
            }

            // Return Fatal if we can't resolve the elasticity hierarchy
            if (!elasticityHierarchies.TryGetValue(product.HierarchyId, out SmElasticityHierarchy elasticityHierarchy))
            {
                _logger.Warning("Can't find Elasticity Hierarchy by HierarchyId {HierarchyId} for Product {ProductId}", product.HierarchyId, product.ProductId);
                return result.Fatal(ProductState.InvalidElasticityHierarchy);
            }

            var recommendations = new List<SmCalcRecommendation>();
            foreach (var schedule in schedules)
            {
                // Apply the product mask to this schedule and skip of not aligned
                if (product.ProductScheduleMask != null && (schedule.ScheduleNumber & product.ProductScheduleMask.Value) != 0)
                {
                    result.ScheduleProductMaskFilterCount++;
                    continue;
                }

                // Skip products where the max markdown is exceeded
                if (product.ProductMaxMarkdown != null && product.ProductMaxMarkdown.Value >= schedule.MarkdownCount)
                {
                    result.ScheduleMaxMarkdownFilterCount++;
                    continue;
                }

                if (product.ProductHasExceededFlowlineThreshold == 1)
                {
                    result.ScheduleExceededFlowlineThresholdFilterCount++;
                    continue;
                }

                var crossProduct = GetCrossProduct(schedule, product.PriceLadder);
                result.ScheduleCrossProductCount = crossProduct.Length;

                foreach (var path in crossProduct)
                {
                    var prices = path.Prices.Select(x => x ?? 0).ToArray();
                    var recommendation = new SmCalcRecommendation(scenario, schedule, prices, revisionId);
                    
                    var calculateResult =  CalculatePricePath(
                        product: ref result,
                        recommendation: ref recommendation,
                        scenario: scenario,
                        modelId: modelId,
                        revisionId: revisionId, 
                        decayHierarchy: decayHierarchy, 
                        elasticityHierarchy: elasticityHierarchy, 
                        priceLadder: product.PriceLadder, 
                        scheduleId: schedule.ScheduleNumber, 
                        schedulePricePath: path);

                    if (calculateResult)
                    {
                        // Get top 10 by Total Revenue
                        recommendations.InsertAfter(recommendation, 10, x => recommendation.TotalRevenue > x.TotalRevenue);
                    }

                    cancellationToken.ThrowIfCancellationRequested();
                }
            }
            
            // For initial runs, calculate CSP (where revision id = 0)
            if (revisionId == 0) { 
                var noChangeSchedule = SmDenseSchedule.NoMarkdowns(scenario.ScheduleWeekMin, scenario.ScheduleWeekMax);
                var cspPricePath = SmSchedulePricePath.Build(noChangeSchedule.WeekMin, noChangeSchedule.WeekMax, noChangeSchedule.MarkdownWeeks, product.PriceLadder.Type, product.PriceLadder.Values);

                var prices = cspPricePath.Prices.Select(x => x ?? 0).ToArray();
                var cspRecommendation = new SmCalcRecommendation(scenario, noChangeSchedule, prices, revisionId, isCsp: true);

                var cspResult = CalculatePricePath(
                    product: ref result,
                    recommendation: ref cspRecommendation,
                    scenario: scenario,
                    modelId: modelId,
                    revisionId: revisionId,
                    decayHierarchy: decayHierarchy,
                    elasticityHierarchy: elasticityHierarchy,
                    priceLadder: product.PriceLadder,
                    scheduleId: noChangeSchedule.ScheduleNumber,
                    schedulePricePath: cspPricePath);
                
                if (cspResult)
                    recommendations.InsertAfter(cspRecommendation, recommendations.Count + 1, x => cspRecommendation.TotalRevenue > x.TotalRevenue, true);

                result.ScheduleCount++;
            }

            if (!recommendations.Any())
            {
                _logger.Warning("No recommendations made for {ProductId}", product.ProductId);
                return result.Ok();
            }

            // Set rank, store and set stats
            var results = new List<SmCalcRecommendation>();
            foreach (var ordered in recommendations.Select((x, i) => new { recomendation = x, index = i }))
            {
                var recommendation = ordered.recomendation;
                recommendation.Rank = recommendations.Count - ordered.index;
                results.Add(recommendation);
            }

            ExpandProjectionWeeks(ref result, ref results, scenario, revisedDiscounts);
            return result.Ok(results);
        }

        public void ExpandProjectionWeeks(ref SmCalcProduct product, ref List<SmCalcRecommendation> recommendations, SmScenario scenario, List<decimal> revisedDiscounts)
        {
            // Calculate week period
            var scheduleMask = scenario.ScheduleMask;
            var firstWeek = scenario.ScheduleWeekMin;
            var lastWeek = scenario.ScheduleWeekMax;
            var weekCount = lastWeek - firstWeek + 1;

            // Skip if we already have n weeks
            var sparseRecommendations = recommendations
                .Where(x => x.Projections.Count < weekCount)
                .ToList();

            if (!sparseRecommendations.Any())
                return;

            // Create a week map
            var markdownIndex = 0;
            var weeks = Enumerable.Range(firstWeek, weekCount)
                .Select((x, i) =>
                {
                    var bit = x - firstWeek;
                    var isMarkdown = ((1 << bit) & scheduleMask) != 0;
                    return new
                    {
                        Week = x,
                        WeekIndex = i,
                        IsMarkdown = isMarkdown,
                        MarkdownIndex = isMarkdown ? markdownIndex++ : (int?)null
                    };
                })
                .ToList();

            // Foreach sparse recommendation append missing weeks
            foreach (var recommendation in sparseRecommendations)
            {
                var projections = recommendation.Projections;
                var originalSellingPrice = product.OriginalSellingPrice;
                var currentMarkdownDepth = product.CurrentMarkdownDepth;

                var trailingWeeks = weeks
                    .Skip(projections.Count)
                    .ToList();

                var lastProjection = projections.LastOrDefault();
                var trailingProjections = new List<SmCalcRecommendationProjection>();
                var lastDiscount = projections.Any() ? lastProjection.Discount : currentMarkdownDepth;

                var previousDiscount = lastDiscount;
                var previousPrice = originalSellingPrice * (1 - previousDiscount);

                foreach (var item in trailingWeeks)
                {
                    var discount = lastDiscount;
                    var markdownCount = projections.Any() ? lastProjection.MarkdownCount : 0;
                    var accumulatedMarkdownCount = projections.Any() ? lastProjection.AccumulatedMarkdownCount : 0;
                    var stock = projections.Any() ? lastProjection.Stock : 0;

                    if (revisedDiscounts != null && item.MarkdownIndex != null  && item.IsMarkdown && item.MarkdownIndex <= revisedDiscounts.Count - 1)
                        discount = revisedDiscounts[(int)item.MarkdownIndex];

                    var price = originalSellingPrice * (1 - discount);

                    var projection = new SmCalcRecommendationProjection
                    {
                        Week = item.Week,
                        Discount = discount,
                        Price = price,
                        MarkdownCount = markdownCount,
                        AccumulatedMarkdownCount = accumulatedMarkdownCount,
                        Quantity = 0,
                        Revenue = 0,
                        MarkdownCost = (price - previousPrice) * stock,
                        Stock = stock,
                        Decay = 0,
                        Elasticity = 0
                    };

                    previousDiscount = discount;
                    previousPrice = originalSellingPrice * (1 - previousDiscount);

                    trailingProjections.Add(projection);
                    lastProjection = projection;
                }

                projections.AddRange(trailingProjections);
            }
        }
        
        public bool CalculatePricePath(
                ref SmCalcProduct product,
                ref SmCalcRecommendation recommendation,
                SmScenario scenario,
                int modelId,
                int revisionId,
                SmDecayHierarchy decayHierarchy,
                SmElasticityHierarchy elasticityHierarchy,
                SmProductPriceLadder priceLadder,
                int scheduleId,
                SmSchedulePricePath schedulePricePath)
        {
            var scheduleStageMax = scenario.ScheduleStageMax;
            var currentMarkdownType = product.CurrentMarkdownType;
            var accumulatedMarkdownCount = product.CurrentMarkdownCount;
            var totalRevenue = 0M;
            var totalCost = 0M;
            var totalMarkdownCost = 0M;
            var accumulatedMarkdownCountOffset = 0;
            var previousPrice = product.CurrentSellingPrice;
            var previousQuantity = product.CurrentSalesQuantity;
            var accumulatedStockChange = 0;
            var projections = new List<SmCalcRecommendationProjection>();
            
            var weeks = schedulePricePath.Weeks;

            var firstWeek = schedulePricePath.Weeks[0];
            var pricePath = schedulePricePath.Prices;
            var salesFlexFactors = product.SalesFlexFactor;

            for (var week = 0; week < weeks.Length; week++)
            {
                // TODO write out price change 
                var priceChange = pricePath[week];

                var flexFactor = salesFlexFactors[week];
                var weekMarkdownConstraint = product.MarkdownTypeConstraint[week];
                var weekMinimumRelativePercentagePriceChange = product.MinimumRelativePercentagePriceChange[week];
                var weekMinDiscountNew = product.MinDiscountsNew[week];
                var weekMinDiscountFurther = product.MinDiscountsFurther[week];
                var weekMaxDiscountNew = product.MaxDiscountsNew[week];
                var weekMaxDiscountFurther = product.MaxDiscountsFurther[week];

                var price = product.CurrentSellingPrice;
                var currentCostPrice = product.CurrentCostPrice;

                if (priceChange != null)
                {
                    switch (priceLadder.Type)
                    {
                        case SmPriceLadderType.Percent:
                            price = product.OriginalSellingPrice * (1 - priceChange.Value);
                            break;
                        case SmPriceLadderType.Fixed:
                            price = product.OriginalSellingPrice - (1 - priceChange.Value);
                            break;
                        default:
                            throw new ArgumentOutOfRangeException();
                    }
                }

                if (price > product.CurrentSellingPrice)
                {
                    product.HighPredictionCount++;
                    return false;
                }

                // A change in price advances stage and resets
                var elasticity = 0.0M;
                if (previousPrice != price)
                {
                    accumulatedMarkdownCount++;
                    accumulatedMarkdownCountOffset = 0;

                    var absolutePriceChange = previousPrice - price;
                    var relativePriceChange = (previousPrice - price) / previousPrice;

                    if (absolutePriceChange < product.MinimumAbsolutePriceChange)
                    {
                        product.MinimumAbsolutePriceChangeNotMetCount++;
                        return false;
                    }

                    if (absolutePriceChange < product.MinimumAbsolutePriceChange)
                    {
                        product.MinimumAbsolutePriceChangeNotMetCount++;
                        return false;
                    }

                    if (relativePriceChange < weekMinimumRelativePercentagePriceChange)
                    {
                        product.MinimumRelativePercentagePriceChangeNotMetCount++;
                        return false;
                    }

                    currentMarkdownType = (accumulatedMarkdownCount == 1)
                        ? MarkdownType.New
                        : MarkdownType.Further;

                    if (!weekMarkdownConstraint.HasFlag(currentMarkdownType))
                    {
                        product.InvalidMarkdownTypeCount++;
                        return false;
                    }

                    switch (currentMarkdownType)
                    {
                        case MarkdownType.New:
                            if (weekMinDiscountNew > priceChange || weekMaxDiscountNew < priceChange)
                            {
                                product.DiscountPercentageOutsideAllowedRangeCount++;
                                return false;
                            }
                            else
                                break;
                        case MarkdownType.Further:
                            if (weekMinDiscountFurther > priceChange || weekMaxDiscountFurther < priceChange)
                            {
                                product.DiscountPercentageOutsideAllowedRangeCount++;
                                return false;
                            }
                            else
                                break;
                        default:
                            throw new ArgumentOutOfRangeException(); ;
                    }

                    // Use the elasticity for this calculation
                    if (accumulatedMarkdownCount > 0 && accumulatedMarkdownCountOffset == 0)
                    {
                        var elasticityStage = Math.Min(accumulatedMarkdownCount, Math.Min(elasticityHierarchy.MaxStage, scheduleStageMax));
                        elasticity = elasticityHierarchy.TryGetValue(elasticityStage, out SmElasticity e) ? e.PriceElasticity : 1.0M;
                    }
                }
                else
                {
                    currentMarkdownType = accumulatedMarkdownCount == 0 && product.CurrentSellingPrice >= product.OriginalSellingPrice
                        ? MarkdownType.FullPrice
                        : MarkdownType.Existing;

                    if (!weekMarkdownConstraint.HasFlag(currentMarkdownType))
                    {
                        product.InvalidMarkdownTypeCount++;
                        return false;
                    }
                }

                // Get decay
                var decay = 1.0M;
                if (accumulatedMarkdownCountOffset > 0)
                {
                    var decayStage = Math.Min(accumulatedMarkdownCount, Math.Min(decayHierarchy.MaxStage, scheduleStageMax));
                    decay = decayHierarchy.TryGetValue(decayStage, accumulatedMarkdownCountOffset, out SmDecay d) ? d.Decay : 1.0M;
                }

                // Calculate the predicted quantity sold			
                var predictedQuantity = (int)Math.Round(accumulatedMarkdownCount == product.CurrentMarkdownCount
                    ? previousQuantity * decay
                    : previousQuantity * decay * (1 - (((previousPrice - price) / previousPrice) * elasticity)));

                // Calculate projected stock
                var stock = Math.Max(product.CurrentStock - accumulatedStockChange, 0);

                // Ensure predicted quantity sold is non-negative
                var adjustedQuantity = Math.Max(predictedQuantity, 0) * flexFactor;

                // Ensure predicted quantity sold is not more than available stock
                var quantity = Math.Min(stock, adjustedQuantity);

                // Calculate Metrics
                var revenue = price * quantity;
				var cost = currentCostPrice * quantity;
                var markdownCost = (previousPrice - price) * stock;       

                projections.Add(new SmCalcRecommendationProjection
                {
                    Week = firstWeek + week,
                    Discount = priceChange ?? product.CurrentMarkdownDepth,
                    Price = price,
                    Quantity = (int)quantity,
                    Revenue = revenue,
                    Stock = stock,
                    MarkdownCost = markdownCost,
                    AccumulatedMarkdownCount = accumulatedMarkdownCount, 
                    MarkdownCount = accumulatedMarkdownCount - product.CurrentMarkdownCount,
                    Decay = decay,
                    Elasticity = elasticity,
                    MarkdownType = currentMarkdownType
                });

                totalRevenue += revenue;
				totalCost += cost;
                totalMarkdownCost += markdownCost;
                previousPrice = price;
                previousQuantity = (int)quantity;
                accumulatedStockChange += (int)quantity;
                accumulatedMarkdownCountOffset++;

                // TODO test accumulatedStockChange > CurrentStock
                if (totalRevenue < 0)
                {
                    product.NegativeRevenueCount++;
                    return false;
                }
            }
            
            var terminalStock = Math.Max((product.CurrentStock - accumulatedStockChange), 0);
            var sellThroughTarget = product.CurrentStock - (product.CurrentStock * product.SellThroughTarget);
            var sellThroughTerminalStock = terminalStock == 0 ? sellThroughTarget : terminalStock;
            var sellThroughRate = product.SellThroughTarget > 0 ? (sellThroughTarget / sellThroughTerminalStock) : 0;

            // Assign values
            recommendation.PricePath = pricePath.Select(x => x ?? 0).ToArray();
            recommendation.IsCsp = (schedulePricePath.MarkdownCount == 0);
            recommendation.TotalMarkdownCount = accumulatedMarkdownCount;
            recommendation.TotalRevenue = totalRevenue;
            recommendation.TotalCost = totalCost;
            recommendation.TotalMarkdownCost = totalMarkdownCost;
            recommendation.FinalDiscount = projections.Any() ? projections.Last().Discount : 0;
            recommendation.StockValue = product.CurrentSellingPrice * product.CurrentStock;
            recommendation.EstimatedProfit = totalRevenue - totalCost;
            recommendation.EstimatedSales = accumulatedStockChange;
            recommendation.TerminalStock = terminalStock;
            recommendation.SellThroughRate = sellThroughRate;
            recommendation.SellThroughTarget = sellThroughTarget;
            recommendation.FinalMarkdownType = currentMarkdownType;
            recommendation.Projections = projections;

            return true;
        }

        private static SmDepth GetDiscountLadderDepth(SmProduct product)
        {
            var priceLadder = product.PriceLadder;

            var currentMarkdownDepth = 0M;
            var currentDiscountLadderDepth = (decimal?) null;

            var priceDelta = product.OriginalSellingPrice - product.CurrentSellingPrice;

            if (priceDelta > 0)
            {
                currentMarkdownDepth = priceDelta / product.OriginalSellingPrice;
                if (currentMarkdownDepth < priceLadder.Values.First())
                    currentDiscountLadderDepth = priceLadder.Values.First();
                else if (currentMarkdownDepth > priceLadder.Values.Last())
                    currentDiscountLadderDepth = priceLadder.Values.Last();
                else
                    currentDiscountLadderDepth = priceLadder.Values.FirstOrDefault(x => x >= currentMarkdownDepth);
            }

            return new SmDepth
            {
                MarkdownDepth = currentMarkdownDepth,
                DiscountLadderDepth = currentDiscountLadderDepth
            };
        }

        private SmSchedulePricePath[] GetCrossProduct(SmDenseSchedule schedule, SmProductPriceLadder ladder)
        {
            var constraintId = schedule.Constraints.GetHashCode();
            var key = new { schedule.MarkdownCount, Mask = schedule.ScheduleNumber, ladder.PriceLadderId, constraintId };
            if (!_ladderPathCache.TryGetValue(key, out SmSchedulePricePath[] result))
            {
                result = schedule.Expand(ladder);
                _ladderPathCache.Set(key, result);
            }
            return result;
        }
        
        public async Task Save(List<SmCalcProduct> results, SmS3Path s3Path)
        {
            await _s3Repository.WriteRecords(s3Path, results);
        }
    }
}

