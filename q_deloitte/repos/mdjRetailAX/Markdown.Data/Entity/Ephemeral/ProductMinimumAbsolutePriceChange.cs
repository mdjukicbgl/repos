namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductMinimumAbsolutePriceChange
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public decimal MinimumAbsolutePriceChange { get; set; }
    }
}