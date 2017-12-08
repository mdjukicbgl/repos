using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Markdown.Data.Entity.App;

namespace Markdown.Data.Repository.Ef
{
    public interface IPriceLadderRepository
    {
        Task<PriceLadder> GetById(int priceLadderId);
    }
    
    public class PriceLadderRepository : BaseEntityRepository<Hierarchy>, IPriceLadderRepository
    {
        public PriceLadderRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
        }

        public async Task<PriceLadder> GetById(int priceLadderId)
        {
            return await Context
                .PriceLadders
                .Include(x => x.Values)
                .SingleOrDefaultAsync(x => x.PriceLadderId == priceLadderId);
        }
    }
}



