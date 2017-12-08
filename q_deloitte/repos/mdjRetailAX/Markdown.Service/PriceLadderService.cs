using System.Threading.Tasks;
using Markdown.Data.Repository.Ef;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IPriceLadderService
    {
        Task<SmPriceLadder> GetById(int priceLadderId);
    }

    public class PriceLadderService : IPriceLadderService
    {
        private readonly IPriceLadderRepository _priceLadderRepository;

        public PriceLadderService(IPriceLadderRepository priceLadderRepository)
        {
            _priceLadderRepository = priceLadderRepository;
        }

        public async Task<SmPriceLadder> GetById(int priceLadderId)
        {
            var entity = await _priceLadderRepository.GetById(priceLadderId);
            return SmPriceLadder.Build(entity);
        }
    }
}
