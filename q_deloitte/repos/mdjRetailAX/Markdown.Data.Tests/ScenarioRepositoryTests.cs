using System.Linq;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Moq;
using Xunit;

using RetailAnalytics.Data;

using Markdown.Data.Repository.Ef;
using Markdown.Data.Entity.App;
using Serilog;

namespace Markdown.Data.Tests
{
    public class ScenarioRepositoryTests
    {
        private readonly Mock<ILogger> _mockLogger = new Mock<ILogger>();
        private readonly Mock<MarkdownEfContext> _mockDbContext = new Mock<MarkdownEfContext>();
        private readonly Mock<IDbConnectionProvider> _mockDbConnectionProvider = new Mock<IDbConnectionProvider>();
		private readonly Mock<IOrganisationDataProvider> _mockOrganisationDataProvider = new Mock<IOrganisationDataProvider>();

        private readonly Mock<MarkdownEfContextFactory> _mockDbContextFactory;

        public ScenarioRepositoryTests()
        {
            _mockDbContextFactory = new Mock<MarkdownEfContextFactory>(_mockDbConnectionProvider.Object, _mockOrganisationDataProvider.Object);

            var scenarioTotals = new TestAsyncEnumerable<ScenarioTotals>(new List<ScenarioTotals>
                    {
                        new ScenarioTotals{ScenarioId = 100,ProductsCost=1000},
                        new ScenarioTotals{ScenarioId = 101,ProductsCost=10001}
                    }.AsQueryable()
              );

            _mockDbContext.Setup(context => context.ScenarioTotals).ReturnsDbSet(scenarioTotals);

            _mockDbContextFactory.Setup(mockFactory => mockFactory.Create(It.IsAny<DbContextFactoryOptions>()))
                .Returns(_mockDbContext.Object);
        }

        [Fact]
        public async void Get_ScenarioTotals_ReturnsResultForScenarioIdSpecifiedOnly()
        {
            var repository = new ScenarioRepository(_mockDbContextFactory.Object);

            var result = await repository.GetScenarioTotals(101);

            Assert.True(result.ScenarioId == 101);
        }
    }
}

