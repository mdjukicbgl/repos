namespace Markdown.Data.Entity.App
{
    public class FunctionGroupType : IBaseEntity
    {
        public int FunctionGroupTypeId { get; set; }
        public int SequenceOrder { get; set; }
        public string Name { get; set; }
    }
}