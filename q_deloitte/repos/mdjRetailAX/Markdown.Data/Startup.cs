using Markdown.Data.Repository.Ef;
using Markdown.Data.Repository.S3;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.DependencyInjection;
using SimpleInjector;

namespace Markdown.Data
{
    public static class Startup
    {
        public static void RegisterDependancies(Container container)
        {
            container.Register<IDbContextFactory<MarkdownEfContext>, MarkdownEfContextFactory>(Lifestyle.Scoped);

            container.Register<IS3Repository, S3JsonRepository>(Lifestyle.Scoped);
            container.Register<IEphemeralRepository, EphemeralRepository>(Lifestyle.Scoped);
            container.Register<IFunctionRepository, FunctionRepository>(Lifestyle.Scoped);
            container.Register<IRecommendationRepository, RecommendationRepository>(Lifestyle.Scoped);
            container.Register<IRecommendationProductRepository, RecommendationProductRepository>(Lifestyle.Scoped);
            container.Register<IRecommendationProductSummaryRepository, RecommendationProductSummaryRepository>(Lifestyle.Scoped);
            container.Register<IScenarioRepository, ScenarioRepository>(Lifestyle.Scoped);
            container.Register<IScenarioSummaryRepository, ScenarioSummaryRepository>(Lifestyle.Scoped);
            container.Register<IScenarioHierarchyFilterRepository, ScenarioHierarchyFilterRepository>(Lifestyle.Scoped);
            container.Register<IScenarioProductFilterRepository, ScenarioProductFilterRepository>(Lifestyle.Scoped);
			container.Register<IAccessControlRepository, AccessControlRepository>(Lifestyle.Scoped);
        }

        public static void RegisterDependanciesWeb(Container container)
        {
            container.Register<IDbContextFactory<MarkdownEfContext>, MarkdownEfContextFactory>(Lifestyle.Scoped);

            container.Register<IS3Repository, S3JsonRepository>(Lifestyle.Scoped);
            container.Register<IS3CsvRepository, S3CsvRepository>(Lifestyle.Scoped);
            container.Register<IHierarchyRepository, HierarchyRepository>(Lifestyle.Scoped);
            container.Register<IRecommendationRepository, RecommendationRepository>(Lifestyle.Scoped);
            container.Register<IRecommendationProductRepository, RecommendationProductRepository>(Lifestyle.Scoped);
            container.Register<IRecommendationProductSummaryRepository, RecommendationProductSummaryRepository>(Lifestyle.Scoped);
            container.Register<IScenarioRepository, ScenarioRepository>(Lifestyle.Scoped);
            container.Register<IScenarioSummaryRepository, ScenarioSummaryRepository>(Lifestyle.Scoped);
            container.Register<IScenarioHierarchyFilterRepository, ScenarioHierarchyFilterRepository>(Lifestyle.Scoped);
            container.Register<IDashboardRepository, DashboardRepository>(Lifestyle.Scoped);
            container.Register<IFileUploadRepository, FileUploadRepository>(Lifestyle.Scoped);
            container.Register<IPriceLadderRepository, PriceLadderRepository>(Lifestyle.Scoped);
            container.Register<IFileUploadScenarioRepository, FileUploadScenarioRepository>(Lifestyle.Scoped);
            container.Register<IScenarioProductFilterRepository, ScenarioProductFilterRepository>(Lifestyle.Scoped);
            container.Register<IAccessControlRepository, AccessControlRepository>(Lifestyle.Scoped);
        }

        public static void RegisterServicesDependancies(IServiceCollection services)
        {
            services.AddScoped<IDbContextFactory<MarkdownEfContext>,MarkdownEfContextFactory>();
            services.AddScoped<IAccessControlRepository,AccessControlRepository>();
        }
    }
}
