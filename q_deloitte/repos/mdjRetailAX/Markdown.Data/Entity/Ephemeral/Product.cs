using Markdown.Common.Enums;

namespace Markdown.Data.Entity.Ephemeral
{
    public class Product
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public string Name { get; set; }

        public int CurrentMarkdownCount { get; set; }
        public int CurrentStock { get; set; }
        public decimal CurrentCostPrice { get; set; }
        public int CurrentSalesQuantity { get; set; }
        public decimal CurrentSellingPrice { get; set; }
        public decimal OriginalSellingPrice { get; set; }
        public decimal CurrentCover { get; set; }
        public MarkdownType CurrentMarkdownType { get; set; }
    }
}