namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductParameterValues
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int? Mask { get; set; }
        public int? MaxMarkdown { get; set; }
        public int HasExceededFlowlineThreshold { get; set; }

        // Min
        // Max
    }
}