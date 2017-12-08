namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductWeekParameterValues
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int Week { get; set; }
        public decimal MinimumRelativePercentagePriceChange { get; set; }
    }
}