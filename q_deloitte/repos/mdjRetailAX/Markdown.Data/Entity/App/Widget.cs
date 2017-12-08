using System.Collections.Generic;

namespace Markdown.Data.Entity.App
{
    public class Widget : IBaseEntity
    {
        public int WidgetId { get; set; }
        public int WidgetTypeId { get; set; }

        public virtual WidgetType WidgetType { get; set; }

        public virtual List<WidgetInstance> Instances { get; set; } = new List<WidgetInstance>();
        public int OrganisationId { get; set; }
    }
}