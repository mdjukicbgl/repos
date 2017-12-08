using System.Collections.Generic;
using System.Linq;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmDashboard
    {
        public int DashboardId { get; set; }
        public int LayoutTypeId { get; set; }
        public string LayoutTypeName { get; set; }
        public string DashboardTitle { get; set; }
        public List<VmDashboardWidget> Items { get; set; }
        
        public static VmDashboard Build(SmDashboard entity)
        {
            if (entity == null)
                return null;

            return new VmDashboard
            {
                DashboardId = entity.DashboardId,
                LayoutTypeId = (int)entity.DashboardLayoutType,
                LayoutTypeName = entity.DashboardLayoutType.ToString(),
                DashboardTitle = entity.Title,
                Items = VmDashboardWidget.Build(entity.Widgets)
            };
        }
        
        public static List<VmDashboard> Build(List<SmDashboard> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}