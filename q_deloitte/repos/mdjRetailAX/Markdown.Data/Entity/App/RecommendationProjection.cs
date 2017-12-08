using System;
using System.Text;
using System.Security.Cryptography;
using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class RecommendationProjection : IBaseEntity
    {
        private Guid _recommendationGuid;
        private Guid _recommendationProjectionGuid;

        private readonly HashAlgorithm _hashAlgorithm;

        public RecommendationProjection()
        {
        }

        public RecommendationProjection(HashAlgorithm hashAlgorithm)
        {
            _hashAlgorithm = hashAlgorithm;
        }

        [Key]
        public Guid RecommendationProjectionGuid
        {
            get
            {
                if (_recommendationProjectionGuid == Guid.Empty && _hashAlgorithm != null)
                    _recommendationProjectionGuid = new Guid(_hashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes($"{RecommendationGuid}:{Week}")));
                return _recommendationProjectionGuid;
            }
            set => _recommendationProjectionGuid = value;
        }

        public Guid RecommendationGuid
        {
            get
            {
                if (_recommendationGuid == Guid.Empty && Recommendation != null)
                    _recommendationGuid = Recommendation.RecommendationGuid;
                return _recommendationGuid;
            }
            set => _recommendationGuid = value;
        }

        public int ClientId { get; set; }
        public int ScenarioId { get; set; }

        public int Week { get; set; }
        public decimal Discount { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public decimal Revenue { get; set; }
        public int Stock { get; set; }
        public decimal MarkdownCost { get; set; }
        public int AccumulatedMarkdownCount { get; set; }
        public int MarkdownCount { get; set; }
        public decimal Elasticity { get; set; }
        public decimal Decay { get; set; }
        public int MarkdownTypeId { get; set; }

        public Recommendation Recommendation { get; set; }
    }
}