using System.Linq;
using System.Collections.Generic;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmDashboard
    {
        public int DashboardId { get; set; }
        public Common.Enums.DashboardLayoutType DashboardLayoutType { get; set; }
        public string Title { get; set; }
        public List<SmDashboardWidget> Widgets { get; set; }
        
        public static SmDashboard Build(Dashboard entity)
        {
            if (entity == null)
                return null;

            return new SmDashboard
            {
                DashboardId = entity.DashboardId,
                DashboardLayoutType = (Common.Enums.DashboardLayoutType)entity.DashboardLayoutTypeId,
                Title = entity.Title,
                Widgets = SmDashboardWidget.Build(entity.Widgets)
            };
        }
        
        public static List<SmDashboard> Build(List<Dashboard> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}