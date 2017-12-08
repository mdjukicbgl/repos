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
    public interface IScenarioHierarchyFilterRepository : IBaseEntityRepository<ScenarioHierarchyFilter>
    {
        Task Create(List<ScenarioHierarchyFilter> entities);
        Task<List<ScenarioHierarchyFilter>> GetAllByScenarioId(int clientId, int scenarioId);
        Task DeleteByScenarioId(int scenarioId);
    }

    public class ScenarioHierarchyFilterRepository : BaseEntityRepository<ScenarioHierarchyFilter>, IScenarioHierarchyFilterRepository
    {
        public ScenarioHierarchyFilterRepository(IDbContextFactory<MarkdownEfContext> contextFactory) :
            base(contextFactory)
        {
        }

        // TODO add client id
        public async Task<List<ScenarioHierarchyFilter>> GetAllByScenarioId(int clientId, int scenarioId)
        {
            return await Context.ScenarioHierarchyFilters
                .Include(x => x.Scenario)
                                .Where(x => x.Scenario.OrganisationId == clientId && x.ScenarioId == scenarioId)
                .ToListAsync();
        }

        // TODO add client id
        public async Task Create(List<ScenarioHierarchyFilter> entities)
        {
            using (var transaction = Context.Connection.BeginTransaction())
            {
                await DeleteByScenarioId(entities.First().ScenarioId);

                var recommendationCopyHelper =
                    new PostgreSQLCopyHelper<ScenarioHierarchyFilter>("scenario_hierarchy_filter")
                        .MapInteger("hierarchy_id", x => x.HierarchyId)
                        .MapInteger("scenario_id", x => x.ScenarioId);
                recommendationCopyHelper.SaveAll((NpgsqlConnection)Context.Connection, entities);

                transaction.Commit();
            }
        }

        // TODO add client id
        public async Task DeleteByScenarioId(int scenarioId)
        {
            await Context.Connection.ExecuteAsync(
                @"DELETE FROM scenario_hierarchy_filter WHERE scenario_id = @ScenarioId",
                new
                {
                    ScenarioId = scenarioId
                });
        }
    }
}



