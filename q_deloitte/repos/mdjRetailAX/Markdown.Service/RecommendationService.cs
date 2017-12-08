﻿using System;
using System.Threading.Tasks;

using Markdown.Service.Models;
using Markdown.Data.Repository.Ef;
using Markdown.Common.Filtering;
using System.Collections.Generic;
 using Markdown.Common.Enums;

namespace Markdown.Service
{
    public interface IRecommendationProductService
    {
        Task<SmRecommendationProductSummary> GetRecommendationByGuid(int clientId, Guid guid);
        Task<SmRecommendationProductSummary> GetRecommendationByScenarioAndProductId(int clientId, int scenarioId, int productId);
        Task<QueryResults<SmRecommendationProductSummary>> GetRecommendations(int scenarioId,
													int pageIndex,
													int pageSize,
                                                    List<IFilter> filters,
													List<ISort> sorts);
        
		Task<List<string>> GetMultiSelectValues(int scenarioId,
                                                    IMultiSelectField field
                                                   );

        Task<int> AcceptAll(int clientId, int scenarioId);
        Task<int> RejectAll(int clientId, int scenarioId);

        Task<SmRecommendationProductSummary> Accept(int clientId, int scenarioId, Guid recommendationGuid);
        Task<SmRecommendationProductSummary> Reject(int clientId, int scenarioId, Guid recommendationGuid);
        Task<SmRecommendationProductSummary> Revise(int clientId, int scenarioId, int productId);
        Task<SmRecommendationProductSummary> Revise(int clientId, int scenarioId, Guid recommendationGuid);

    }

    public class RecommendationProductService : IRecommendationProductService
    {
        private readonly IRecommendationProductRepository _recommendationProductRepository;
        private readonly IRecommendationProductSummaryRepository _recommendationProductSummaryRepository;

        public RecommendationProductService(IRecommendationProductRepository recommendationProductRepository, IRecommendationProductSummaryRepository recommendationProductSummaryRepository)
        {
            _recommendationProductRepository = recommendationProductRepository;
            _recommendationProductSummaryRepository = recommendationProductSummaryRepository;
        }

        public async Task<SmRecommendationProductSummary> GetRecommendationByGuid(int clientId, Guid guid)
        {
            var result = await _recommendationProductSummaryRepository.GetByRecommendationGuid(clientId, guid);
            return result == null ? null : SmRecommendationProductSummary.Build(result);
        }
        public async Task<SmRecommendationProductSummary> GetRecommendationByScenarioAndProductId(int clientId, int scenarioId, int productId)
        {
            var result = await _recommendationProductSummaryRepository.GetByScenarioAndProductId(clientId, scenarioId, productId);
            return result == null ? null : SmRecommendationProductSummary.Build(result);
        }

		public async Task<QueryResults<SmRecommendationProductSummary>> GetRecommendations(int scenarioId,
													int pageIndex,
													int pageSize,
                                                    List<IFilter> filters,
													List<ISort> sorts)
        {
            // TODO validate access to scenarioId/guid
            var results = await _recommendationProductSummaryRepository.GetAll(scenarioId,pageIndex,pageSize,filters,sorts);
            return SmRecommendationProductSummary.Build(results);
        }

        public async Task<int> AcceptAll(int clientId, int scenarioId)
        {
            return await UpdateState(clientId, scenarioId, DecisionState.Accepted);
        }

        public async Task<int> RejectAll(int clientId, int scenarioId)
        {
            return await UpdateState(clientId, scenarioId, DecisionState.Rejected);
        }

        public async Task<SmRecommendationProductSummary> Accept(int clientId, int scenarioId, Guid recommendationGuid)
        {
            var product = await _recommendationProductSummaryRepository.GetByRecommendationGuid(clientId, recommendationGuid);
            return await UpdateState(clientId, scenarioId, product.ProductId, DecisionState.Accepted);
        }

        public async Task<SmRecommendationProductSummary> Reject(int clientId, int scenarioId, Guid recommendationGuid)
        {
            var product = await _recommendationProductSummaryRepository.GetByRecommendationGuid(clientId, recommendationGuid);
            return await UpdateState(clientId, scenarioId, product.ProductId, DecisionState.Rejected);
        }

        public async Task<SmRecommendationProductSummary> Revise(int clientId, int scenarioId, int productId)
        {
            return await UpdateState(clientId, scenarioId, productId, DecisionState.Revised);
        }

        public async Task<SmRecommendationProductSummary> Revise(int clientId, int scenarioId, Guid recommendationGuid)
        {
            var product = await _recommendationProductSummaryRepository.GetByRecommendationGuid(clientId, recommendationGuid);
            return await UpdateState(clientId, scenarioId, product.ProductId, DecisionState.Revised);
        }

        private async Task<SmRecommendationProductSummary> UpdateState(int clientId, int scenarioId, int productId, DecisionState state)
        {
            // Update decision state changing 'DecisionRecommendationGuid'
            await _recommendationProductRepository.SetDecisionState(clientId, scenarioId, productId, state);

            // Return updated product and 'DecisionRecommendationGuid'
            var result = await _recommendationProductSummaryRepository.GetByScenarioAndProductId(clientId, scenarioId,  productId);
            return SmRecommendationProductSummary.Build(result);
        }

        private async Task<int> UpdateState(int clientId, int scenarioId, DecisionState state)
        {
            return await _recommendationProductRepository.SetDecisionState(clientId, scenarioId, state);
        }

        public async Task<List<string>> GetMultiSelectValues(int scenarioId, IMultiSelectField field)
        {
            return await _recommendationProductSummaryRepository.GetMultiSelectValues(scenarioId, field);
        }
    }
}
