namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductSalesTax
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int Week { get; set; }
        public decimal Rate { get; set; }
    }
}
