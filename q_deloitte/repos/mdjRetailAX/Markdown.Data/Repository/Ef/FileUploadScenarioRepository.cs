using System.Threading.Tasks;

using Dapper;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Markdown.Data.Entity.App;

namespace Markdown.Data.Repository.Ef
{
    public interface IFileUploadScenarioRepository
    {
        Task<FileUploadScenario> add(int FileUploadId, int ScenarioId);
    }

    public class FileUploadScenarioRepository : BaseEntityRepository<FileUploadScenario>, IFileUploadScenarioRepository
    {
        public FileUploadScenarioRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
        }

        public async Task<FileUploadScenario> add(int fileUploadId, int scenarioId)
        {
            var entity = new FileUploadScenario
            {
                FileUploadId = fileUploadId,
                ScenarioId = scenarioId
            };

            Context.FileUploadScenarios.Add(entity);
            await Context.SaveChangesAsync();
            return entity;
        }
    }
}



