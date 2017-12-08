using Markdown.Common.Enums;

namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductSalesFlexFactor
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int Week { get; set; }
        public decimal FlexFactor { get; set; }
    }
}