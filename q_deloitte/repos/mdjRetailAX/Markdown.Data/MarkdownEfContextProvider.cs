using RetailAnalytics.Data;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace Markdown.Data
{
    public class MarkdownEfContextFactory : IDbContextFactory<MarkdownEfContext>
    {
        private readonly IDbConnectionProvider _dbConnectionProvider;
        private readonly IOrganisationDataProvider _organisationDataProvider;

       public MarkdownEfContextFactory(IDbConnectionProvider dbConnectionProvider, IOrganisationDataProvider organisationIdProvider)
        {
            _dbConnectionProvider = dbConnectionProvider;
            _organisationDataProvider = organisationIdProvider;
        }

        public virtual MarkdownEfContext Create(DbContextFactoryOptions options)
        {
            return new MarkdownEfContext(_dbConnectionProvider,_organisationDataProvider.OrganisationId );
        }
    }
}
