using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using RetailAnalytics.Data;

namespace Markdown.Data
{
    public interface IMarkdownSqlContext : ISqlContext
    {
    }

    public class MarkdownSqlContext : SqlContext, IMarkdownSqlContext
    {
        public MarkdownSqlContext(ISqlSettings settings, IDbConnectionProvider provider) : base(provider)
        {
        }
    }
}
