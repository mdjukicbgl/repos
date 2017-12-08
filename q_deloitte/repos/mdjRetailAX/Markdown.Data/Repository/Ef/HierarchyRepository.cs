using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Markdown.Data.Entity.App;

namespace Markdown.Data.Repository.Ef
{
    public interface IHierarchyRepository { 
        Task<List<Hierarchy>> GetAll();
        Task<List<Hierarchy>> GetByDepth(int depth);
        Task<List<Hierarchy>> GetChildren(int hierarchyId);
    }
    
    public class HierarchyRepository : BaseEntityRepository<Hierarchy>, IHierarchyRepository
    {
        public HierarchyRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
        }

        public async Task<List<Hierarchy>> GetAll()
        {
            return await Context.Hierarchies.ToListAsync();
        }

        public async Task<List<Hierarchy>> GetByDepth(int depth)
        {
            return await Context.Hierarchies
                .Where(x => x.Depth == depth)
                .ToListAsync();
        }

        public async Task<List<Hierarchy>> GetChildren(int hierarchyId)
        {
            return await Context.Hierarchies
                .Where(x => x.ParentId == hierarchyId)
                .ToListAsync();
        }
    }
}



