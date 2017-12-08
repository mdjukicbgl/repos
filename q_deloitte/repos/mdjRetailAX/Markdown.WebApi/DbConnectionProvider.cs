using System;
using System.Data;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Npgsql;
using RetailAnalytics.Data;
using Serilog;

namespace Markdown.WebApi
{
    public class DbConnectionProvider : IDbConnectionProvider
    {
        private readonly ILogger _logger;
        private IDbConnection _connection;
        private readonly Lazy<IDbConnection> _lazyConnection;
        public IDbConnection Connection => _lazyConnection.Value;

        public DbConnectionProvider(ILogger logger, ISqlSettings settings)
        {
            _logger = logger;
            _lazyConnection = new Lazy<IDbConnection>(() =>
            {
                if (_connection != null)
                    return _connection;

                _connection = CreateConnection(settings);
                return _connection;
            });
		}

        private IDbConnection CreateConnection(ISqlSettings settings)
        {
            Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;

            var pgSql = new NpgsqlConnection(settings.EphemeralConnectionString);
            pgSql.Notice += (sender, args) => _logger.Information("psql NOTICE: {Notice} at {Where}", args.Notice.MessageText, args.Notice.Where);

            try
            {
                pgSql.Open();
            }
            catch (Exception ex)
            {
                throw new Exception("Error opening connection to database (" + settings.EphemeralConnectionString + "): " + ex.Message, ex);
            }

            return pgSql;
        }

        public void Dispose()
        {
            try
            {
                _connection?.Close();
                _connection?.Dispose();
                _connection = null;
            }
            catch (Exception e)
            {
                _logger.Error(e, "Exception disposing DbConnectionProvider. Probably OK to ignore.");
            }
        }
    }
}