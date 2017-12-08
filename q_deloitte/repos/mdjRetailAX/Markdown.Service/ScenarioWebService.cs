using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using Markdown.Common.Enums;
using Markdown.Common.Filtering;

using Markdown.Service.Models;
using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef;
using Markdown.Data.Repository.S3;

namespace Markdown.Service
{
    public interface IScenarioWebService
    {
        Task<SmScenarioSummary> Get(int clientId, int scenarioId);
        Task<QueryResults<SmScenarioSummary>> GetAll(List<IFilter> filters, List<ISort> Sorts, int pageIndex, int pageSize);
        Task<SmScenarioTotals> GetScenarioTotals(int scenarioId);
        Task<int> Create(string name, int week, int scenarioMask, int scenarioWeekMin, int scenarioWeekMax,
                         int markdownCountStartWeek, int defaultMarkdownType, DecisionState defaultDecisionState,
                         bool allowPromoAsMarkdown, decimal minimumPromoPercentage, int organisationId, 
                         int userId, List<int> productIds, List<int> hierarchyIds);
    }
    
    public class ScenarioWebService : IScenarioWebService
    {
        // TODO read from settings
        public const string ApiKey = "p4b8yDR77Y5F13tt31TMi7kzSiooRjZv7ghIWobM";
        public const string BaseUrl = "https://o4fspke8bj.execute-api.eu-west-1.amazonaws.com/dev";

        private readonly IScenarioRepository _scenarioRepository;
        private readonly IScenarioSummaryRepository _scenarioSummaryRepository;
        private readonly IScenarioHierarchyFilterRepository _scenarioHierarchyFilterRepository;
        private readonly IScenarioProductFilterRepository _scenarioProductFilterRepository;

        public ScenarioWebService(IScenarioRepository scenarioRepository, IScenarioSummaryRepository scenarioSummaryRepository, IScenarioProductFilterRepository scenarioProductFilterRepository, IScenarioHierarchyFilterRepository scenarioHierarchyFilterRepository)
        {
            _scenarioRepository = scenarioRepository;
            _scenarioSummaryRepository = scenarioSummaryRepository;
            _scenarioHierarchyFilterRepository = scenarioHierarchyFilterRepository;
            _scenarioProductFilterRepository = scenarioProductFilterRepository;
        }

        public async Task<SmScenarioSummary> Get(int clientId, int scenarioId)
        {
            var result = await _scenarioSummaryRepository.GetSingle(clientId, scenarioId);
            return SmScenarioSummary.Build(result);
        }

        public async Task<QueryResults<SmScenarioSummary>> GetAll(List<IFilter> filters, List<ISort> sorts, int pageIndex, int pageSize)
        {
            var results = await _scenarioSummaryRepository.GetAll(filters, sorts, pageIndex, pageSize);
            return SmScenarioSummary.Build(results);
        }

        public async Task<SmScenarioTotals> GetScenarioTotals(int scenarioId)
        {
            var results = await _scenarioRepository.GetScenarioTotals(scenarioId);
            return SmScenarioTotals.Build(results);
        }

        public async Task<int> Create(string name, int week, int scenarioMask, int senarioWeekMin,
                                      int scenarioWeekMax, int markdownCountStartWeek, int defaultMarkdownType, 
                                      DecisionState defaultDecisionState, bool allowPromoAsMarkdown, decimal minimumPromoPercentage,
                                      int organisationId, int userId, List<int> productIds, List<int> hierarchyIds)
        { 
            var scenario = SmScenario.Build(name, week, scenarioMask, senarioWeekMin, 
                                            scenarioWeekMax, markdownCountStartWeek, defaultMarkdownType,
                                            defaultDecisionState, allowPromoAsMarkdown, minimumPromoPercentage, 
                                            organisationId,userId );

            var scenarioId = await _scenarioRepository.CreateOrUpdate(scenario.Week, scenario.ScheduleWeekMin,
                scenario.ScheduleWeekMax, scenario.ScheduleStageMin,
                scenario.ScheduleStageMax, scenario.StageMax, scenario.StageOffsetMax, scenario.PriceFloor,
                  scenario.OrganisationId,scenario.CreatedBy, scenario.ScenarioName, scenario.ScheduleMask,
                    scenario.MarkdownCountStartWeek, scenario.DefaultMarkdownType, 
                scenario.DefaultDecisionState);

            if (hierarchyIds.Any())
            {
                var filters = hierarchyIds
                    .Select(x => new ScenarioHierarchyFilter {HierarchyId = x, ScenarioId = scenarioId})
                    .ToList();

                await _scenarioHierarchyFilterRepository.Create(filters);
            }

            if (productIds.Any())
            {
                var products = productIds
                    .Select(x => new ScenarioProductFilter { ProductId = x, ScenarioId = scenarioId })
                    .ToList();

                await _scenarioProductFilterRepository.Create(products);
            }

            return scenarioId;
        }
    }
}
