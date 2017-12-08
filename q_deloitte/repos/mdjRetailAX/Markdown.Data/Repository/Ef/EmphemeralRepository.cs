using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using Npgsql;
using NpgsqlTypes;
using Serilog;

namespace Markdown.Data.Repository.Ef
{
    public interface IEphemeralRepository
    {
        Task GenerateModel(int modelId, Func<SqlMapper.GridReader, Task> action);
        Task GetScenarioData(int modelRunId, int scenarioId, int week, int scheduleWeekMin, int scheduleWeekMax, int markdownCountStartWeek, int partitionCount, bool allowPromoAsMarkdown, decimal minimumPromoPercentage, Func<SqlMapper.GridReader, Task> action);
    }

    public class EphemeralRepository : IEphemeralRepository
    {
        private readonly ILogger _logger;
        private readonly IMarkdownSqlContext _context;
        private readonly int _prefix;

        public EphemeralRepository(ILogger logger, IMarkdownSqlContext context)
        {
            _logger = logger;
            _context = context;
            _prefix = new Random().Next() % 10000;
        }
    
        public async Task GetScenarioData(int modelRunId, int scenarioId, int week, int scheduleWeekMin, int scheduleWeekMax, int markdownCountStartWeek, int partitionCount, bool allowPromoAsMarkdown, decimal minimumPromoPercentage, Func<SqlMapper.GridReader, Task> action)
        {
            var cursorNames = new List<string>();
            
            using (var tran = BeginTransaction())
            {
                using (var command = new NpgsqlCommand("ephemeral" + _prefix + "_get_scenario_data", (NpgsqlConnection) _context.Connection, (NpgsqlTransaction) tran) {CommandType = CommandType.StoredProcedure})
                {
                    command.Parameters.AddWithValue("p_model_run_id", NpgsqlDbType.Integer, modelRunId);
                    command.Parameters.AddWithValue("p_scenario_id", NpgsqlDbType.Integer, scenarioId);
                    command.Parameters.AddWithValue("p_scenario_week", NpgsqlDbType.Integer, week);
                    command.Parameters.AddWithValue("p_schedule_week_min", NpgsqlDbType.Integer, scheduleWeekMin);
                    command.Parameters.AddWithValue("p_schedule_week_max", NpgsqlDbType.Integer, scheduleWeekMax);
                    command.Parameters.AddWithValue("p_weeks_to_extrapolate_on", NpgsqlDbType.Integer, 3); //TODO: To add ability to configure parameter
                    command.Parameters.AddWithValue("p_decay_backdrop", NpgsqlDbType.Numeric, 0.9); //TODO: To add ability to configure parameter
                    command.Parameters.AddWithValue("p_observed_decay_min", NpgsqlDbType.Numeric, 0.3); //TODO: To add ability to configure parameter
                    command.Parameters.AddWithValue("p_observed_decay_max", NpgsqlDbType.Numeric, 1.2); //TODO: To add ability to configure parameter
                    command.Parameters.AddWithValue("p_markdown_count_start_week", NpgsqlDbType.Integer, markdownCountStartWeek); //TODO: To add ability to configure parameter    
                    command.Parameters.AddWithValue("p_partition_count", NpgsqlDbType.Integer, partitionCount);
                    command.Parameters.AddWithValue("p_allow_promo_as_markdown", NpgsqlDbType.Boolean, allowPromoAsMarkdown);//
                    command.Parameters.AddWithValue("p_minimum_promo_percentage", NpgsqlDbType.Numeric, minimumPromoPercentage);//
                    command.Parameters.AddWithValue("p_observed_decay_cap", NpgsqlDbType.Integer, 2); //TODO: To add ability to configure parameter

                    using (var reader = command.ExecuteReader(CommandBehavior.SequentialAccess))
                    {
                        while (await reader.ReadAsync())
                            cursorNames.Add(reader.GetString(0));
                    }
                }

                using (var multi =
                    _context.Connection.QueryMultiple(
                        string.Join(" ", cursorNames.Select(x => $"FETCH ALL IN \"{x}\";")),
                        (NpgsqlConnection) _context.Connection, (NpgsqlTransaction) tran))
                {
                    await action(multi);
                }
            }
        }

        public async Task GenerateModel(int modelId, Func<SqlMapper.GridReader, Task> action)
        {
            var cursorNames = new List<string>();

            using (var tran = BeginTransaction())
            {
                using (var command = new NpgsqlCommand("ephemeral" + _prefix + "_get_model_data", (NpgsqlConnection) _context.Connection, (NpgsqlTransaction) tran) {CommandType = CommandType.StoredProcedure})
                {
                    command.Parameters.AddWithValue("p_model_week", NpgsqlDbType.Integer, 10000);
                    await command.ExecuteNonQueryAsync();
                }

                using (var command = new NpgsqlCommand("ephemeral" + _prefix + "_generate_model", (NpgsqlConnection) _context.Connection, (NpgsqlTransaction) tran) {CommandType = CommandType.StoredProcedure})
                {
                    command.Parameters.AddWithValue("p_model_id", NpgsqlDbType.Integer, modelId);

                    using (var reader = command.ExecuteReader(CommandBehavior.SequentialAccess))
                    {
                        while (await reader.ReadAsync())
                            cursorNames.Add(reader.GetString(0));
                    }
                }

                using (var multi = _context.Connection.QueryMultiple(string.Join(" ", cursorNames.Select(x => $"FETCH ALL IN \"{x}\";")), (NpgsqlConnection) _context.Connection, (NpgsqlTransaction) tran))
                {
                    await action(multi);
                }
            }
        }

        private IDbTransaction BeginTransaction()
        {
            var transaction = _context.Connection.BeginTransaction();

            try
            {
                var rawSchemaText = File.ReadAllText(Path.Combine(Directory.GetCurrentDirectory(), "Scripts/schema_script.sql"));
                var schemaText = rawSchemaText.Replace("ephemeral.", "ephemeral" + _prefix + "_");
                using (var command = new NpgsqlCommand(schemaText, (NpgsqlConnection)_context.Connection, (NpgsqlTransaction)transaction) { CommandType = CommandType.Text })
                    command.ExecuteNonQuery();

                var rawProcsText = File.ReadAllText(Path.Combine(Directory.GetCurrentDirectory(), "Scripts/procs_script.sql"));
                var procsText = rawProcsText.Replace("ephemeral.", "ephemeral" + _prefix + "_");
                using (var command = new NpgsqlCommand(procsText, (NpgsqlConnection)_context.Connection, (NpgsqlTransaction)transaction) { CommandType = CommandType.Text })
                    command.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                _logger.Error(e, "Critical error installing emphemeral code: {Exception}", e);
                throw;
            }
            
            return transaction;
        }
    }
}



