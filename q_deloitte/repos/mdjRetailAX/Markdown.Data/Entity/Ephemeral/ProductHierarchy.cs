namespace Markdown.Data.Entity.Ephemeral
{
    public class ProductHierarchy
    {
        public int ProductId { get; set; }
        public int PartitionNumber { get; set; }
        public int HierarchyId { get; set; }
        public string HierarchyName { get; set; }
        public string HierarchyPath { get; set; }
        public string ProductName { get; set; }
        public int Depth { get; set; }
    }
}