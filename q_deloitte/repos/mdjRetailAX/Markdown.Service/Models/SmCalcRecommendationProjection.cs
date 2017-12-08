using System.Diagnostics;
using Markdown.Common.Enums;

namespace Markdown.Service.Models
{
    [DebuggerDisplay("{Week}: Discount={Discount.ToString(\"0.00\")}, Price={Price.ToString(\"0.00\")}, Quantity={Quantity}")]
    public struct SmCalcRecommendationProjection
    {
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
        public MarkdownType MarkdownType { get; set; }
    }
}