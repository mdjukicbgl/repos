using System;
using System.Collections.Generic;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmRecommendationSummary
    {
        public Guid RecommendationSummaryGuid { get; set; }
        public Guid RecommendationProductGuid { get; set; }

        public int ClientId { get; set; }
        public int ScenarioId { get; set; }
        public int ProductId { get; set; }

        public int ScheduleId { get; set; }
        public int ScheduleMask { get; set; }
        public int ScheduleMarkdownCount { get; set; }
        public bool IsCsp { get; set; }
        public string PricePathPrices { get; set; }
        public int PricePathHashCode { get; set; }
        public int RevisionId { get; set; }

        public int Rank { get; set; }
        public int TotalMarkdownCount { get; set; }
        public int TerminalStock { get; set; }
        public decimal TotalRevenue { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalMarkdownCost { get; set; }
        public decimal? FinalDiscount { get; set; }
        public decimal StockValue { get; set; }
        public decimal EstimatedProfit { get; set; }
        public decimal EstimatedSales { get; set; }
        public decimal SellThroughRate { get; set; }
        public decimal SellThroughTarget { get; set; }
        public int FinalMarkdownTypeId { get; set; }
        
        public List<SmRecommendationProjectionSummary> Projections { get; set; }

        public static SmRecommendationSummary Build(RecommendationSummary entity)
        {
            if (entity == null)
                return null;

            return new SmRecommendationSummary
            {
                RecommendationSummaryGuid = entity.RecommendationSummaryGuid,
                RecommendationProductGuid = entity.RecommendationProductGuid,

                ClientId = entity.ClientId,
                ScenarioId = entity.ScenarioId,
                ProductId = entity.ProductId,

                ScheduleId = entity.ScheduleId,
                ScheduleMask = entity.ScheduleMask,
                ScheduleMarkdownCount = entity.ScheduleMarkdownCount,
                IsCsp = entity.IsCsp,
                PricePathPrices = entity.PricePathPrices,
                PricePathHashCode = entity.PricePathHashCode,
                RevisionId = entity.RevisionId,

                Rank = entity.Rank,
                TotalMarkdownCount = entity.TotalMarkdownCount,
                TerminalStock = entity.TerminalStock,
                TotalRevenue = entity.TotalRevenue,
                TotalCost = entity.TotalCost,
                TotalMarkdownCost = entity.TotalMarkdownCost,
                FinalDiscount = entity.FinalDiscount,
                StockValue = entity.StockValue,
                EstimatedProfit = entity.EstimatedProfit,
                EstimatedSales = entity.EstimatedSales,
                SellThroughRate = entity.SellThroughRate,
                SellThroughTarget = entity.SellThroughTarget,
                FinalMarkdownTypeId = entity.FinalMarkdownTypeId,

                Projections = SmRecommendationProjectionSummary.Build(entity.Projections)
            };
        }

    }
}