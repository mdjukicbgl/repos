﻿using System.Linq;
using System.Data;
using System.Threading.Tasks;
using System.Collections.Generic;

using Microsoft.EntityFrameworkCore.Infrastructure;

using Serilog;

using Npgsql;
using NpgsqlTypes;
using PostgreSQLCopyHelper;

using Markdown.Data.Entity.App;

namespace Markdown.Data.Repository.Ef
{
    public interface IRecommendationRepository : IBaseEntityRepository<Recommendation>
    {
        Task Write(int clientId, int scenarioId, int revisionId, int partitionId, int productId, List<Recommendation> entities);
	}

    public class RecommendationRepository : BaseEntityRepository<Recommendation>, IRecommendationRepository
    {
        private readonly ILogger _logger;

        public static PostgreSQLCopyHelper<Recommendation> Helper =
            new PostgreSQLCopyHelper<Recommendation>("recommendation")
                .MapUUID("recommendation_guid", x => x.RecommendationGuid)
                .MapUUID("recommendation_product_guid", x => x.RecommendationProductGuid)

                .MapInteger("client_id", x => x.ClientId)
                .MapInteger("scenario_id", x => x.ScenarioId)

                .MapInteger("schedule_id", x => x.ScheduleId)
                .MapInteger("schedule_mask", x => x.ScheduleMask)
                .MapInteger("schedule_markdown_count", x => x.ScheduleMarkdownCount)
                .MapBoolean("is_csp", x => x.IsCsp)
                .MapVarchar("price_path_prices", x => x.PricePathPrices)
                .MapInteger("price_path_hash_code", x => x.PricePathHashCode)
                .MapInteger("revision_id", x => x.RevisionId)

                .MapInteger("rank", x => x.Rank)
                .MapInteger("total_markdown_count", x => x.TotalMarkdownCount)
                .MapNumeric("terminal_stock", x => x.TerminalStock)
                .MapNumeric("total_revenue", x => x.TotalRevenue)
                .MapNumeric("total_cost", x => x.TotalCost)
                .MapNumeric("total_markdown_cost", x => x.TotalMarkdownCost)
                .MapNumeric("final_discount", x => x.FinalDiscount)
                .MapNumeric("stock_value", x => x.StockValue)
                .MapNumeric("estimated_profit", x => x.EstimatedProfit)
                .MapNumeric("estimated_sales", x => x.EstimatedSales)
                .MapNumeric("sell_through_rate", x => x.SellThroughRate)
                .MapNumeric("sell_through_target", x => (int)x.SellThroughTarget)
                .MapInteger("created_by", x => x.CreatedBy)

                .MapInteger("final_markdown_type_id", x => (int)x.FinalMarkdownTypeId);

        public RecommendationRepository(ILogger logger, IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
            _logger = logger;
        }

        public async Task Write(int clientId, int scenarioId, int revisionId, int partitionId, int productId, List<Recommendation> entities)
        {
            using (var transaction = Context.Connection.BeginTransaction())
            {
                _logger.Information("Cleaning up entities (client id: {ClientId}, scenario id: {ScenarioId}, partition id: {PartitionId}, product id: {ProductId}, revision id: {RevisionId})", clientId, scenarioId, partitionId, productId, revisionId);
                using (var command = new NpgsqlCommand("fn_delete_result_partition_revision", (NpgsqlConnection)Context.Connection, (NpgsqlTransaction)transaction) { CommandType = CommandType.StoredProcedure })
                {
                    command.Parameters.AddWithValue("p_client_id", NpgsqlDbType.Integer, clientId);
                    command.Parameters.AddWithValue("p_scenario_id", NpgsqlDbType.Integer, scenarioId);
                    command.Parameters.AddWithValue("p_partition_number", NpgsqlDbType.Integer, partitionId);
                    command.Parameters.AddWithValue("p_product_id", NpgsqlDbType.Integer, productId);
                    command.Parameters.AddWithValue("p_revision_id", NpgsqlDbType.Integer, revisionId);
                    await command.ExecuteNonQueryAsync();
                }

                _logger.Information("Writing {ProductCount} entities", entities.Count);

                Helper.SaveAll((NpgsqlConnection)Context.Connection, entities);
                RecommendationProjectionRepository.Helper.SaveAll((NpgsqlConnection)Context.Connection, entities.SelectMany(x => x.Projections));

                transaction.Commit();
            }
        }
    }
}
