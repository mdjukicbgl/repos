using System.Data;

namespace RetailAnalytics.Data
{
    public interface ISqlContext
    {
        IDbConnection Connection { get; }
    }

    public class SqlContext : ISqlContext
    {
        protected IDbConnectionProvider ConnectionProvider { get; }
        public IDbConnection Connection => ConnectionProvider.Connection;

        public SqlContext(IDbConnectionProvider provider)
        {
            ConnectionProvider = provider;
        }
    }
}
