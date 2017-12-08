using System.Linq;
using System.Collections.Generic;

using Markdown.Common.Enums;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmDashboardWidget
    {
        public int DashboardId { get; set; }
        public int WidgetId { get; set; }
        public int WidgetInstanceId { get; set; }
        public WidgetType WidgetType { get; set; }
        public string Title { get; set; }
        public int Order { get; set; }
        public string Json { get; set; }
        public int JsonVersion { get; set; }
        public bool IsVisible { get; set; }
        
        public static VmDashboardWidget Build(SmDashboardWidget model)
        {
            if (model == null)
                return null;

            return new VmDashboardWidget
            {
                DashboardId = model.DashboardId,
                WidgetId = model.WidgetId,
                WidgetType = model.WidgetType,
                WidgetInstanceId = model.WidgetInstanceId,
                Title = model.Title,
                Order = model.Order,
                Json = model.Json,
                JsonVersion = model.JsonVersion,
                IsVisible = model.IsVisible
            };
        }
        
        public static List<VmDashboardWidget> Build(List<SmDashboardWidget> models)
        {
            return models?.Select(Build).ToList();
        }
    }
}