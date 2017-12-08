using System;
using System.Text;
using System.Collections.Generic;
using System.Security.Cryptography;

namespace Markdown.Data.Entity.App
{
    public class RecommendationProduct : IBaseEntity
    {
        private Guid _recommendationProductGuid;
        private readonly HashAlgorithm _hashAlgorithm;

        public RecommendationProduct()
        {
        }

        public RecommendationProduct(HashAlgorithm hashAlgorithm)
        {
            _hashAlgorithm = hashAlgorithm;
        }

        public Guid RecommendationProductGuid
        {
            get
            {
                if (_recommendationProductGuid == Guid.Empty && _hashAlgorithm != null)
                    _recommendationProductGuid = new Guid(_hashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes($"{ClientId}:{ScenarioId}:{ProductId}:{PriceLadderId}")));
                return _recommendationProductGuid;
            }
            set => _recommendationProductGuid = value;
        }

        public int ClientId { get; set; }
        public int ScenarioId { get; set; }

        public int ModelId { get; set; }
        public int ProductId { get; set; }
        public int PriceLadderId { get; set; }
        public string ProductName { get; set; }

        public int PartitionCount { get; set; }
        public int PartitionNumber { get; set; }

        public int HierarchyId { get; set; }
        public string HierarchyName { get; set; }

        public int ScheduleCount { get; set; }
        public int ScheduleCrossProductCount { get; set; }
        public int ScheduleProductMaskFilterCount { get; set; }
        public int ScheduleMaxMarkdownFilterCount { get; set; }

        public int HighPredictionCount { get; set; }
        public int NegativeRevenueCount { get; set; }
        public int InvalidMarkdownTypeCount { get; set; }

        public int CurrentMarkdownCount { get; set; }
        public int CurrentMarkdownTypeId { get; set; }
        public decimal CurrentSellingPrice { get; set; }
        public decimal OriginalSellingPrice { get; set; }
        public decimal CurrentCostPrice { get; set; }
        public int CurrentStock { get; set; }
        public int CurrentSalesQuantity { get; set; }

        public decimal SellThroughTarget { get; set; }

        public decimal CurrentMarkdownDepth { get; set; }
        public decimal? CurrentDiscountLadderDepth { get; set; }

        public string StateName { get; set; }
        public string DecisionStateName { get; set; }
		public DateTime CreatedAt { get; set; }
		public DateTime? UpdatedAt { get; set; }
		public int CreatedBy { get; set; }
		public int? UpdatedBy { get; set; }

        public virtual List<Recommendation> Recommendations { get; set; } = new List<Recommendation>();
    }
}