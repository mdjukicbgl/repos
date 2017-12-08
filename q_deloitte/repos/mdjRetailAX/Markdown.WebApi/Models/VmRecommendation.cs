using System;
using System.Collections.Generic;
using System.Linq;
using Markdown.Common.Enums;
using Markdown.Common.Filtering;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmRecommendation
    {
        public Guid RecommendationProductGuid { get; set; }
        public Guid RecommendationGuid { get; set; }
        public int ScenarioId { get; set; }
        public int RevisionId { get; set; }
        public string HierarchyName { get; set; }
        public int ScheduleId { get; set; }
        public int ScheduleMask { get; set; }
        public int PriceLadderId { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public decimal OriginalSellingPrice { get; set; }
        public decimal CurrentSellingPrice { get; set; }
        public decimal CurrentMarkdownDepth { get; set; }
        public decimal? CurrentDiscountLadderDepth { get; set; }
        public decimal SellThroughTarget { get; set; }
        public int TerminalStockUnits { get; set; }
        public string PricePathPrices { get; set; }
        public string PricePathDiscounts { get; set; }
        public decimal TotalRevenue { get; set; }
        public List<VmRecommendationProjection> Projections { get; set; }

        public string Status { get; set; }
        public decimal MarkdownCost { get; set; }
        public RecommendationStatus CalcStatus { get; set; }
        public RecommendationSubStatus CalcSubStatus { get; set; }
        
        public static VmRecommendation Build(SmRecommendationProductSummary model)
        {
            if (model == null)
                return null;

            var decision = model.DecisionRecommendation;

            return new VmRecommendation
            {
                RecommendationProductGuid = model.RecommendationProductGuid,
                RecommendationGuid = decision?.RecommendationSummaryGuid ?? model.RecommendationProductGuid,
                ScenarioId = model.ScenarioId,
                RevisionId = decision?.RevisionId ?? 0,
                ScheduleId = decision?.ScheduleId ?? 0,
                ScheduleMask = decision?.ScheduleMask ?? 0,
                PriceLadderId = model.PriceLadderId,
                ProductId = model.ProductId,
                ProductName = model.ProductName,
                HierarchyName = model.HierarchyName,
                OriginalSellingPrice = model.OriginalSellingPrice,
                CurrentSellingPrice = model.CurrentSellingPrice,
                CurrentMarkdownDepth = model.CurrentMarkdownDepth,
                CurrentDiscountLadderDepth = model.CurrentDiscountLadderDepth,
                SellThroughTarget = decision?.SellThroughTarget ?? 0,
                TerminalStockUnits = decision?.TerminalStock ?? 0,
                PricePathPrices = string.Join(";", decision?.Projections?.Select(x => x.Price) ?? new List<decimal>()),
                PricePathDiscounts = string.Join(";", decision?.Projections?.Select(x => x.Discount) ?? new List<decimal>()),
                TotalRevenue = decision?.TotalRevenue ?? 0,
                Projections = VmRecommendationProjection.Build(decision, decision?.Projections),
                MarkdownCost = decision?.TotalMarkdownCost ?? 0,
                Status = model.DecisionState.ToString().ToUpper(),
                CalcStatus = decision?.Projections?.Any() ?? false ? RecommendationStatus.Ok : RecommendationStatus.Fatal,
                CalcSubStatus = decision?.Projections?.Any() ?? false ? RecommendationSubStatus.Ok : RecommendationSubStatus.NoSchedules
            };
        }

        public static List<VmRecommendation> Build(QueryResults<SmRecommendationProductSummary> queryResults)
        {
            return queryResults.Items?.Select(Build).ToList();
        }
    }
}
