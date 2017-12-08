using Microsoft.Extensions.DependencyInjection;
using SimpleInjector;

namespace Markdown.Service
{
    public static class Startup
    {
        public static void RegisterDependancies(Container container)
        {
            // Scoped
            container.Register<IModelService, ModelService>(Lifestyle.Scoped);
            container.Register<IScenarioService, ScenarioService>(Lifestyle.Scoped);
            container.Register<IScheduleService, ScheduleService>(Lifestyle.Scoped);
            container.Register<IPartitionService, PartitionService>(Lifestyle.Scoped);
            container.Register<IScenarioResultService, ScenarioResultService>(Lifestyle.Scoped);
            container.Register<IFunctionService, FunctionService>(Lifestyle.Scoped);
            container.Register<IScenarioWebService, ScenarioWebService>(Lifestyle.Scoped);
            container.Register<IAccessControlService, AccessControlService>(Lifestyle.Scoped);

            Data.Startup.RegisterDependancies(container);
        }

        public static void RegisterDependanciesWeb(Container container)
        {
            // Scoped
            container.Register<IScenarioService, ScenarioService>(Lifestyle.Scoped);
            container.Register<IScenarioWebService, ScenarioWebService>(Lifestyle.Scoped);
            container.Register<IScenarioResultService, ScenarioResultService>(Lifestyle.Scoped);
            container.Register<IHierarchyService, HierarchyService>(Lifestyle.Scoped);
            container.Register<IRecommendationProductService, RecommendationProductService>(Lifestyle.Scoped);
            container.Register<IDashboardWebService, DashboardWebService>(Lifestyle.Scoped);
            container.Register<ICalendarWebService, CalendarWebService>(Lifestyle.Scoped);
            container.Register<IFileUploadService, FileUploadService>(Lifestyle.Scoped);
            container.Register<IPriceLadderService, PriceLadderService>(Lifestyle.Scoped);
            container.Register<IMarkdownService, MarkdownService>(Lifestyle.Scoped);
            container.Register<IAccessControlService, AccessControlService>(Lifestyle.Scoped);

            Data.Startup.RegisterDependanciesWeb(container);
        }

        public static void RegisterServicesDependancies(IServiceCollection services)
        {
            
            services.AddScoped<IAccessControlService, AccessControlService>();


			Data.Startup.RegisterServicesDependancies(services);
        }
    }
}
