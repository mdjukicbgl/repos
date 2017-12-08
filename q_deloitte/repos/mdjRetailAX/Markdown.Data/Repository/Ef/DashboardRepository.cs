using System.Linq;
using System.Threading.Tasks;
using Markdown.Data.Entity.App;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore;

namespace Markdown.Data.Repository.Ef
{
    public interface IDashboardRepository : IBaseEntityRepository<Recommendation>
    {
        Task<Dashboard> Get();
        Task<Dashboard> Get(int dashboardId);
    }

    public class DashboardRepository : BaseEntityRepository<Dashboard>, IDashboardRepository
    {
        public DashboardRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
        }

        public async Task<Dashboard> Get()
        {
            return await Context
                .Dashboards
                .Include(x => x.DashboardLayoutType)
                .Include(x => x.Widgets)
                    .ThenInclude(x => x.WidgetInstance)
                    .ThenInclude(x => x.Widget)
                    .ThenInclude(x => x.WidgetType)
                .FirstOrDefaultAsync();
        }

        public async Task<Dashboard> Get(int dashboardId)
        {
            return await Context
                .Dashboards
                .Include(x => x.DashboardLayoutType)
                .Include(x => x.Widgets)
                    .ThenInclude(x => x.WidgetInstance)
                    .ThenInclude(x => x.Widget)
                    .ThenInclude(x => x.WidgetType)
                .Where(x => x.DashboardId == dashboardId)
                .FirstOrDefaultAsync();
        }
    }
}



