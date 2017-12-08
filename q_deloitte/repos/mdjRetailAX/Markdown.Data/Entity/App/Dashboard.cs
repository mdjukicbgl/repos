using System.Collections.Generic;

namespace Markdown.Data.Entity.App
{
    public class Dashboard : IBaseEntity
    {
        public int DashboardId { get; set; }
        public int DashboardLayoutTypeId { get; set; }
        public string Title { get; set; }

        public virtual DashboardLayoutType DashboardLayoutType { get; set; }
        public virtual List<DashboardWidget> Widgets { get; set; } = new List<DashboardWidget>();
        public virtual List<WidgetInstance> WidgetInstances { get; set; } = new List<WidgetInstance>();
    }
}