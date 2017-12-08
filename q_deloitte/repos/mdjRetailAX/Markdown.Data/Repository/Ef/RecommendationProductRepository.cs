﻿using System.Linq;
using System.Data;
using System.Threading.Tasks;
using System.Collections.Generic;

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Serilog;

using Npgsql;
using NpgsqlTypes;
using PostgreSQLCopyHelper;

using Markdown.Common.Enums;
using Markdown.Data.Entity.App;

namespace Markdown.Data.Repository.Ef
{
    public interface IRecommendationProductRepository : IBaseEntityRepository<RecommendationProduct>
    {
        Task<int> SetDecisionState(int clientId, int scenarioId, DecisionState state);
        Task SetDecisionState(int clientId, int scenarioId, int productId, DecisionState state);
        Task Write(int clientId, int scenarioId, int partitionId, List<RecommendationProduct> entities);
    }

    public class RecommendationProductRepository : BaseEntityRepository<RecommendationProduct>, IRecommendationProductRepository
    {
        private readonly ILogger _logger;

        public static PostgreSQLCopyHelper<RecommendationProduct> Helper =
            new PostgreSQLCopyHelper<RecommendationProduct>("recommendation_product")
                .MapUUID("recommendation_product_guid", x => x.RecommendationProductGuid)

                .MapInteger("client_id", x => x.ClientId)
                .MapInteger("scenario_id", x => x.ScenarioId)

                .MapInteger("model_id", x => x.ModelId)
                .MapInteger("product_id", x => x.ProductId)
                .MapVarchar("product_name", x => x.ProductName)
                .MapInteger("price_ladder_id", x => x.PriceLadderId)

                .MapInteger("partition_number", x => x.PartitionNumber)
                .MapInteger("partition_count", x => x.PartitionCount)

                .MapInteger("hierarchy_id", x => x.HierarchyId)
                .MapVarchar("hierarchy_name", x => x.HierarchyName)

                .MapInteger("schedule_count", x => x.ScheduleCount)
                .MapInteger("schedule_cross_product_count", x => x.ScheduleCrossProductCount)
                .MapInteger("schedule_product_mask_filter_count", x => x.ScheduleProductMaskFilterCount)
                .MapInteger("schedule_max_markdown_filter_count", x => x.ScheduleMaxMarkdownFilterCount)

                .MapInteger("high_prediction_count", x => x.HighPredictionCount)
                .MapInteger("negative_revenue_count", x => x.NegativeRevenueCount)
                .MapInteger("invalid_markdown_type_count", x => x.InvalidMarkdownTypeCount)

                .MapInteger("current_markdown_count", x => x.CurrentMarkdownCount)
                .MapInteger("current_markdown_type_id", x => x.CurrentMarkdownTypeId)
                .MapNumeric("current_selling_price", x => x.CurrentSellingPrice)
                .MapNumeric("original_selling_price", x => x.OriginalSellingPrice)
                .MapNumeric("current_cost_price", x => x.CurrentCostPrice)
                .MapInteger("current_stock", x => x.CurrentStock)
                .MapInteger("current_sales_quantity", x => x.CurrentSalesQuantity)
				.MapInteger("created_by", x => x.CreatedBy)

                .MapNumeric("sell_through_target", x => x.SellThroughTarget)

                .MapNumeric("current_markdown_depth", x => x.CurrentMarkdownDepth)
                .MapNumeric("current_discount_ladder_depth", x => x.CurrentDiscountLadderDepth)

                .MapVarchar("state_name", x => x.StateName)
                .MapVarchar("decision_state_name", x => x.DecisionStateName);

        public RecommendationProductRepository(ILogger logger, IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
            _logger = logger;
        }

        public async Task<int> SetDecisionState(int clientId, int scenarioId, DecisionState state)
        {
            using (var command = new NpgsqlCommand(
                @"UPDATE recommendation_product
                  SET decision_state_name = @p_state
                  WHERE client_id = @p_client_id AND scenario_id = @p_scenario_id",
                (NpgsqlConnection) Context.Connection))
            {
                command.Parameters.AddWithValue("p_client_id", NpgsqlDbType.Integer, clientId);
                command.Parameters.AddWithValue("p_scenario_id", NpgsqlDbType.Integer, scenarioId);
                command.Parameters.AddWithValue("p_state", NpgsqlDbType.Varchar, state.ToString());
                return await command.ExecuteNonQueryAsync();
            }
        }

        public async Task SetDecisionState(int clientId, int scenarioId, int productId, DecisionState state)
        {
            var entity = await Context.RecommendationProduct.SingleAsync(x => x.ClientId == clientId && x.ScenarioId == x.ScenarioId && x.ProductId == productId);
            entity.DecisionStateName = state.ToString();
            Context.RecommendationProduct.Update(entity);
            await Context.SaveChangesAsync();
        }

        public async Task Write(int clientId, int scenarioId, int partitionId, List<RecommendationProduct> entities)
        {
           using (var transaction = Context.Connection.BeginTransaction())
           {
                _logger.Information("Cleaning up entities (client id: {ClientId}, scenario id: {ScenarioId}, partition id: {PartitionId})", clientId, scenarioId, partitionId);
                using (var command = new NpgsqlCommand("fn_delete_result_partition", (NpgsqlConnection)Context.Connection, (NpgsqlTransaction)transaction) { CommandType = CommandType.StoredProcedure })
                {
                    command.Parameters.AddWithValue("p_client_id", NpgsqlDbType.Integer, clientId);
                    command.Parameters.AddWithValue("p_scenario_id", NpgsqlDbType.Integer, scenarioId);
                    command.Parameters.AddWithValue("p_partition_number", NpgsqlDbType.Integer, partitionId);
                    await command.ExecuteNonQueryAsync();
                }

                _logger.Information("Writing {ProductCount} entities", entities.Count);

               Helper.SaveAll((NpgsqlConnection)Context.Connection, entities);
               RecommendationRepository.Helper.SaveAll((NpgsqlConnection)Context.Connection, entities.SelectMany(x => x.Recommendations));
               RecommendationProjectionRepository.Helper.SaveAll((NpgsqlConnection)Context.Connection, entities.SelectMany(x => x.Recommendations).SelectMany(x => x.Projections));

                transaction.Commit();
            }
        }
    }
}
