using System.Threading.Tasks;
using Markdown.Service.Models;
using Markdown.Data.Repository.Ef;

namespace Markdown.Service
{
    public interface IDashboardWebService
    {
        Task<SmDashboard> Get();
    }
    
    public class DashboardWebService : IDashboardWebService
    {
        private readonly IDashboardRepository _dashboardRepository;

        public DashboardWebService(IDashboardRepository dashboardRepository)
        {
            _dashboardRepository = dashboardRepository;
        }

        public async Task<SmDashboard> Get()
        {
            var result = await _dashboardRepository.Get();
            return SmDashboard.Build(result);
        }
    }
}
