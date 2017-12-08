using Markdown.Common.Enums;

namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductWeekMarkdownTypeParameterValues
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int Week { get; set; }
        public MarkdownType MarkdownTypeId { get; set; }
        public decimal MinDiscountPercentage { get; set; }
        public decimal MaxDiscountPercentage { get; set; }
    }
}