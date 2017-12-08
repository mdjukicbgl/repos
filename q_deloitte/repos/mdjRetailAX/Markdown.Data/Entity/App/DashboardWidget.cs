namespace Markdown.Data.Entity.App
{
    public class DashboardWidget : IBaseEntity
    {
        public int DashboardId { get; set; }
        public int WidgetInstanceId { get; set; }
        public virtual WidgetInstance WidgetInstance { get; set; }
    }
}