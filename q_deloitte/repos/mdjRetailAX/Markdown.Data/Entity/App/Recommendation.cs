using System;
using System.Text;
using System.Collections.Generic;
using System.Security.Cryptography;

namespace Markdown.Data.Entity.App
{
    public class Recommendation : IBaseEntity
    {
        private Guid _productGuid;
        private Guid _recommendationGuid; 
        private readonly HashAlgorithm _hashAlgorithm;

        public Recommendation()
        {
        }

        public Recommendation(HashAlgorithm hashAlgorithm)
        {
            _hashAlgorithm = hashAlgorithm;
        }
        
        public Guid RecommendationGuid
        {
            get
            {
                if (_recommendationGuid == Guid.Empty && _hashAlgorithm != null)
                    _recommendationGuid =  new Guid(_hashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes($"{RecommendationProductGuid}:{ScheduleId}:{PricePathHashCode}:{RevisionId}")));
                return _recommendationGuid;
            }
            set => _recommendationGuid = value;
        }

        public Guid RecommendationProductGuid
        {
            get
            {
                if (_productGuid == Guid.Empty && Product != null)
                    _productGuid = Product.RecommendationProductGuid;
                return _productGuid;
            }
            set => _productGuid = value;
        }

        public int ClientId { get; set; }
        public int ScenarioId { get; set; }

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
		public DateTime CreatedAt { get; set; }
		public DateTime? UpdatedAt { get; set; }
		public int CreatedBy { get; set; }
		public int? UpdatedBy { get; set; }

        public RecommendationProduct Product { get; set; }

        public virtual List<RecommendationProjection> Projections { get; set; } = new List<RecommendationProjection>();
    }
}
