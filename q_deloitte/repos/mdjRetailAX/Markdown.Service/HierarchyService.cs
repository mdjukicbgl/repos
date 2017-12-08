using System.Threading.Tasks;
using System.Collections.Generic;
using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IHierarchyService
    {
        Task<List<SmHierarchy>> GetAll(int? depth = null);
        Task<List<SmHierarchy>> GetChildren(int hierarchyId);
    }

    public class HierarchyService : IHierarchyService
    {
        private readonly IHierarchyRepository _productRepository;

        public HierarchyService(IHierarchyRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public async Task<List<SmHierarchy>> GetAll(int? depth = null)
        {
            List<Hierarchy> entities;
            if (depth == null)
                entities = await _productRepository.GetAll();
            else
                entities = await _productRepository.GetByDepth((int)depth);

            return SmHierarchy.Build(entities);
        }

        public async Task<List<SmHierarchy>> GetChildren(int hierarchyId)
        {
            var results = await _productRepository.GetChildren(hierarchyId);
            return SmHierarchy.Build(results);
        }
    }
}
