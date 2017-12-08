using System;
using System.Collections.Generic;
using System.Linq;
using Markdown.Common.Filtering;
using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Moq;
using RetailAnalytics.Data;
using Xunit;

namespace Markdown.Data.Tests
{
    public class ScenarioSummaryRepositoryTests
    {
		private readonly Mock<MarkdownEfContext> _mockDbContext = new Mock<MarkdownEfContext>();
		private readonly Mock<IDbConnectionProvider> _mockDbConnectionProvider = new Mock<IDbConnectionProvider>();
        private readonly Mock<IOrganisationDataProvider> _mockOrganisationDataProvider = new Mock<IOrganisationDataProvider>();

		private readonly Mock<MarkdownEfContextFactory> _mockDbContextFactory;

        public ScenarioSummaryRepositoryTests()
        {
			_mockDbContextFactory = new Mock<MarkdownEfContextFactory>(_mockDbConnectionProvider.Object,_mockOrganisationDataProvider.Object);

            var scenarioSummaries = new TestAsyncEnumerable<ScenarioSummary>(new List<ScenarioSummary>
            {
                new ScenarioSummary
                {
                    ScenarioId = 1,
                    ScenarioName = "ScenarioSummary1"
                },
                new ScenarioSummary
                {
                    ScenarioId = 2,
                    ScenarioName = "ScenarioSummary2"
                },
                new ScenarioSummary
                {
                    ScenarioId = 3,
                    ScenarioName = "ScenarioSummary3"
                },
                new ScenarioSummary
                {
                    ScenarioId = 4,
                    ScenarioName = "ScenarioSummary4"
                },
                new ScenarioSummary
                {
                    ScenarioId = 5,
                    ScenarioName = "ScenarioSummary5"
                }

            }.AsQueryable());

            _mockDbContext.Setup(context => context.ScenarioSummaries).ReturnsDbSet(scenarioSummaries);

            var scenarios = new TestAsyncEnumerable<Scenario>(new List<Scenario>
            {
                new Scenario
                {
                    ScenarioId = 1,
                    ScenarioName = "ScenarioSummary1"
                },
                new Scenario
                {
                    ScenarioId = 2,
                    ScenarioName = "ScenarioSummary2"
                },
                new Scenario
                {
                    ScenarioId = 3,
                    ScenarioName = "ScenarioSummary3"
                },
                new Scenario
                {
                    ScenarioId = 4,
                    ScenarioName = "ScenarioSummary4"
                },
                new Scenario
                {
                    ScenarioId = 5,
                    ScenarioName = "ScenarioSummary5"
                }

            }.AsQueryable());

            _mockDbContext.Setup(context => context.Scenarios).ReturnsDbSet(scenarios);
			_mockDbContextFactory.Setup(mockFactory => mockFactory.Create(It.IsAny<DbContextFactoryOptions>())).Returns(_mockDbContext.Object);
        }

		[Fact]
		public async void GetAll_QueryResults_ItemsLength_IsLessOrEquals_PageSize()
		{
			var recommendationRepository = new ScenarioSummaryRepository(_mockDbContextFactory.Object);
            var model = new ScenarioSummaryQueryParams
            {
                PageSize = 2,
                PageIndex = 1
            };

		    var model2 = new ScenarioSummaryQueryParams
		    {
		        PageSize = 10,
		        PageIndex = 1
		    };
            
            var results = await recommendationRepository.GetAll(model.Filters, model.Sorts,model.PageIndex, model.PageSize);
			Assert.Equal(results.Items.Count, results.PageSize);

			var results2 = await recommendationRepository.GetAll(model2.Filters,model.Sorts, model2.PageIndex, model2.PageSize);
			Assert.True(results2.Items.Count <= results2.PageSize);
		}

		[Fact]
		public async void GetAll_QueryResults_Items_CorrespondTo_PageIndex()
		{
			var recommendationRepository = new ScenarioSummaryRepository(_mockDbContextFactory.Object);
		    var model = new ScenarioSummaryQueryParams
		    {
		        PageSize = 1,
		        PageIndex = 5
		    };

            //This GetAll query should return only the FithItem in the List of set up recommendations.
            var resultsWithOnlyFithItem = await recommendationRepository.GetAll(model.Filters,model.Sorts, model.PageIndex, model.PageSize);

			Assert.True(resultsWithOnlyFithItem.Items[0].ScenarioName.Equals("ScenarioSummary5"));
		}
    }
}
