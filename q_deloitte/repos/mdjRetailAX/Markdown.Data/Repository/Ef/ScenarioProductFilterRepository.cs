using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Dapper;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Npgsql;
using PostgreSQLCopyHelper;

using Markdown.Data.Entity.App;
using Microsoft.EntityFrameworkCore;

namespace Markdown.Data.Repository.Ef
{
    public interface IScenarioProductFilterRepository : IBaseEntityRepository<ScenarioProductFilter>
    {
        Task Create(List<ScenarioProductFilter> entities);
        Task<List<ScenarioProductFilter>> GetAllByScenarioId(int clientId, int scenarioId);
        Task DeleteByScenarioId(int scenarioId);
    }

    public class ScenarioProductFilterRepository : BaseEntityRepository<ScenarioProductFilter>, IScenarioProductFilterRepository
    {
        public ScenarioProductFilterRepository(IDbContextFactory<MarkdownEfContext> contextFactory) :
            base(contextFactory)
        {
        }

        public async Task<List<ScenarioProductFilter>> GetAllByScenarioId(int clientId, int scenarioId)
        {
            return await Context.ScenarioProductFilters
                .Include(x => x.Scenario)
                                .Where(x => x.Scenario.OrganisationId == clientId && x.ScenarioId == scenarioId)
                .ToListAsync();
        }

        public async Task Create(List<ScenarioProductFilter> entities)
        {
            using (var transaction = Context.Connection.BeginTransaction())
            {
                await DeleteByScenarioId(entities.First().ScenarioId);

                var recommendationCopyHelper =
                    new PostgreSQLCopyHelper<ScenarioProductFilter>("scenario_Product_filter")
                        .MapInteger("Product_id", x => x.ProductId)
                        .MapInteger("scenario_id", x => x.ScenarioId);
                recommendationCopyHelper.SaveAll((NpgsqlConnection)Context.Connection, entities);

                transaction.Commit();
            }
        }

        // TODO add client id
        public async Task DeleteByScenarioId(int scenarioId)
        {
            await Context.Connection.ExecuteAsync(
                @"DELETE FROM scenario_Product_filter WHERE scenario_id = @ScenarioId",
                new
                {
                    ScenarioId = scenarioId
                });
        }
    }
}



