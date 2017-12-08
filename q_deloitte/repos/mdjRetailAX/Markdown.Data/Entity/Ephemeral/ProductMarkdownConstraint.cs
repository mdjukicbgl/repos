using Markdown.Common.Enums;

namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductMarkdownConstraint
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int Week { get; set; }
        public MarkdownType MarkdownTypeId { get; set; }
    }
}