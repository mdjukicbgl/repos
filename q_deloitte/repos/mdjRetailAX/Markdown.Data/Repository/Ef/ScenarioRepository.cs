using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Dapper;
using Markdown.Common.Enums;
using Markdown.Data.Entity.App;
using Microsoft.EntityFrameworkCore;

namespace Markdown.Data.Repository.Ef
{
    public interface IScenarioRepository
    {
        Task<int> CreateOrUpdate(int? week, int scheduleWeekMin, int scheduleWeekMax, int scheduleStageMin, int scheduleStageMax, int? stageMax,
            int? stageOffsetMax, decimal? priceFloor, int organisationId,int createdBy, string scenarioName, int scheduleMask, int markdownCountStartWeek, int defaultMarkdownType, DecisionState defaultDecisionState);

        Task<ScenarioTotals> GetScenarioTotals(int scenarioId);
    }

    public class ScenarioRepository : BaseEntityRepository<Scenario>, IScenarioRepository
    {
        public ScenarioRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
        }

        // TODO remove this in favour of log structure
        public async Task<int> CreateOrUpdate(int? week, int scheduleWeekMin, int scheduleWeekMax, int scheduleStageMin, int scheduleStageMax, int? stageMax,
            int? stageOffsetMax, decimal? priceFloor, int organisationId,int createdBy, string scenarioName, int scheduleMask, int markdownCountStartWeek, int defaultMarkdownType, DecisionState defaultDecisionState)
        {
            return await Context.Connection.QuerySingleAsync<int>(
                @"INSERT INTO scenario (week, schedule_week_min, schedule_week_max, schedule_stage_min, schedule_stage_max, stage_max, stage_offset_max, price_floor, organisation_id, created_by, scenario_name, schedule_mask, markdown_count_start_week, default_markdown_type, default_decision_state_name)
                    VALUES (@Week, @ScheduleWeekMin, @ScheduleWeekMax, @ScheduleStageMin, @ScheduleStageMax, @StageMax, @StageOffsetMax, @PriceFloor, @OrganisationId,@CreatedBy, @ScenarioName, @ScheduleMask, @MarkdownCountStartWeek, @DefaultMarkdownType, @DefaultDecisionStateName)
                    ON CONFLICT (scenario_id) DO UPDATE 
                    SET week = @Week,
                        schedule_week_min = @ScheduleWeekMin,
                        schedule_week_max = @ScheduleWeekMax,
                        schedule_stage_min = @ScheduleStageMin,
                        schedule_stage_max = @ScheduleStageMax,
                        stage_max = @StageMax,
                        stage_offset_max = @StageOffsetMax,
                        price_floor = @PriceFloor,      
                        organisation_Id = @OrganisationId,
                        created_by = @CreatedBy,
                        scenario_name = @ScenarioName,
                        schedule_mask = @ScheduleMask,
                        markdown_count_start_week = @MarkdownCountStartWeek,
                        default_markdown_type = @DefaultMarkdownType,
                        default_decision_state_name = @DefaultDecisionStateName
                    RETURNING scenario_id",
                new
                {
                    Week = week,
                    ScheduleWeekMin = scheduleWeekMin,
                    ScheduleWeekMax = scheduleWeekMax,
                    ScheduleStageMin = scheduleStageMin,
                    ScheduleStageMax = scheduleStageMax,
                    StageMax = stageMax,
                    StageOffsetMax = stageOffsetMax,
                    PriceFloor = priceFloor,
                    OrganisationId = organisationId,
                    CreatedBy = createdBy,
                    ScenarioName = scenarioName,
                    ScheduleMask = scheduleMask,
                    MarkdownCountStartWeek = markdownCountStartWeek,
                    DefaultMarkdownType = defaultMarkdownType,
                    DefaultDecisionStateName = defaultDecisionState.ToString()
                });
        }


        public async Task<ScenarioTotals> GetScenarioTotals(int scenarioId)
        {
            var query = Context.ScenarioTotals.Where(x => x.ScenarioId == scenarioId)
                .AsQueryable();

            var result = await query.FirstOrDefaultAsync();

            return result;
        }
    }
}



