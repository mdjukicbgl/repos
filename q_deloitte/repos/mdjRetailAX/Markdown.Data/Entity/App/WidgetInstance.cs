namespace Markdown.Data.Entity.App
{
    public class WidgetInstance : IBaseEntity
    {
        public int WidgetInstanceId { get; set; }
        public int WidgetId { get; set; }
        public int DashboardId { get; set; }
        
        public int LayoutOrdinalId { get; set; }
        public string Title { get; set; }
        public string Json { get; set; }
        public int JsonVersion { get; set; }
        public bool IsVisible { get; set; }

        public virtual Widget Widget { get; set; }
        public virtual Dashboard Dashboard { get; set; }
    }
}