namespace Markdown.Data.Entity.App
{
    public class FunctionInstanceType : IBaseEntity
    {
        public int FunctionInstanceTypeId { get; set; }
        public int SequenceOrder { get; set; }
        public int IsSuccess { get; set; }
        public int IsError { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}