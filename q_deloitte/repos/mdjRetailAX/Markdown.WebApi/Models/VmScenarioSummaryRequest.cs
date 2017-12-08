using System;
using System.Collections.Generic;

using Markdown.Common.Filtering;
using Markdown.Common.Filtering.Values;

namespace Markdown.WebApi.Models
{
    public class VmScenarioSummaryRequest
    { 
        public string ScenarioId { get; set; }

        public string ProductCount { get; set; }
        public string RecommendationCount { get; set; }
        public string LastRunDate { get; set; }
		public string Status { get; set; }

		public string Duration { get; set; }

		public string PartitionTotal { get; set; }
		public string PartitionCount { get; set; }
		public string PartitionErrorCount { get; set; }
		public string PartitionSuccessCount { get; set; }

        public string Sort { get; set; }

        // TODO reflection?
        public List<IFilter> GetValidFilters()
        {
            var results = new List<IFilter>();

            if (!string.IsNullOrWhiteSpace(ScenarioId))
               results.Add(QueryParser.FilterBy(ScenarioSummaryKey.ScenarioId, ScenarioId, int.Parse));      

            if (!string.IsNullOrWhiteSpace(ProductCount))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.ProductCount, ProductCount, long.Parse));

            if (!string.IsNullOrWhiteSpace(RecommendationCount))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.RecommendationCount, RecommendationCount, long.Parse));

            if (!string.IsNullOrWhiteSpace(LastRunDate))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.LastRunDate, LastRunDate, DateTime.Parse));

            if (!string.IsNullOrWhiteSpace(Status))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.Status, Status, x => Enum.Parse(typeof(ScenarioSummaryStatusType), x, true).ToString()));
            
            if (!string.IsNullOrWhiteSpace(Duration))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.Duration, Duration, double.Parse));

            if (!string.IsNullOrWhiteSpace(PartitionTotal))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.PartitionTotal, PartitionTotal, int.Parse));
   
            if (!string.IsNullOrWhiteSpace(PartitionCount))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.PartitionCount, PartitionCount, int.Parse));

            if (!string.IsNullOrWhiteSpace(PartitionErrorCount))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.PartitionErrorCount, PartitionErrorCount, int.Parse));

            if (!string.IsNullOrWhiteSpace(PartitionSuccessCount))
                results.Add(QueryParser.FilterBy(ScenarioSummaryKey.PartitionSuccessCount, PartitionSuccessCount, int.Parse));

            return results;
        }

        public List<ISort> GetSorts()
		{
            return QueryParser.SortBy<ScenarioSummaryKey>(Sort);
		}
    }
}
