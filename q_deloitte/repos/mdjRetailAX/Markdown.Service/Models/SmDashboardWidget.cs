using System;
using System.Collections.Generic;
using System.Linq;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmDashboardWidget
    {
        public int DashboardId { get; set; }
        public int WidgetId { get; set; }
        public int WidgetInstanceId { get; set; }
        public Common.Enums.WidgetType WidgetType { get; set; }
        public string Title { get; set; }
        public int Order { get; set; }
        public string Json { get; set; }
        public int JsonVersion { get; set; }
        public bool IsVisible { get; set; }
        
        public static SmDashboardWidget Build(DashboardWidget entity)
        {
            if (entity == null)
                return null;

            return new SmDashboardWidget
            {
                DashboardId = entity.DashboardId,
                WidgetId = entity.WidgetInstance.WidgetId,
                WidgetType = (Common.Enums.WidgetType)entity.WidgetInstance.Widget.WidgetTypeId,
                WidgetInstanceId = entity.WidgetInstanceId,

                Title = entity.WidgetInstance.Title,
                Order = entity.WidgetInstance.LayoutOrdinalId,
                Json = entity.WidgetInstance.Json,
                JsonVersion = entity.WidgetInstance.JsonVersion,
                IsVisible = entity.WidgetInstance.IsVisible
            };
        }
        
        public static List<SmDashboardWidget> Build(List<DashboardWidget> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}