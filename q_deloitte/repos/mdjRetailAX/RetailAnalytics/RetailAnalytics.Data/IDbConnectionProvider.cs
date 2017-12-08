using System;
using System.Data;

namespace RetailAnalytics.Data
{
    public interface IDbConnectionProvider : IDisposable
    {
        IDbConnection Connection { get; }
    }
}