namespace Markdown.Data.Entity.App
{
    public class WidgetType : IBaseEntity
    {
        public int WidgetTypeId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}