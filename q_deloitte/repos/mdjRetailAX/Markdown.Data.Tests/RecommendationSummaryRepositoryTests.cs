using System.Linq;
using System.Collections.Generic;
using FluentAssertions;
using Microsoft.EntityFrameworkCore.Infrastructure;

using Moq;
using Xunit;

using RetailAnalytics.Data;

using Markdown.Data.Repository.Ef;
using Markdown.Data.Entity.App;
using Markdown.Common.Filtering;

namespace Markdown.Data.Tests
{
	public class RecommendationSummaryRepositoryTests
	{
		private readonly Mock<MarkdownEfContext> _mockDbContext = new Mock<MarkdownEfContext>();
		private readonly Mock<IDbConnectionProvider> _mockDbConnectionProvider = new Mock<IDbConnectionProvider>();
        private readonly Mock<IOrganisationDataProvider> _mockOrganisationDataProvider = new Mock<IOrganisationDataProvider>();

		private readonly Mock<MarkdownEfContextFactory> _mockDbContextFactory;

		public RecommendationSummaryRepositoryTests()
		{
            _mockDbContextFactory = new Mock<MarkdownEfContextFactory>(_mockDbConnectionProvider.Object, _mockOrganisationDataProvider.Object);

		    _mockDbContext
		        .Setup(context => context.RecommendationProductSummary)
		        .ReturnsDbSet(new TestAsyncEnumerable<RecommendationProductSummary>(new List<RecommendationProductSummary>
		        {
		            new RecommendationProductSummary
		            {
                       ClientId = 123,
		                ScenarioId = 100,
		                ProductId = 111,
                        ProductName = "ProductName1",
                        DecisionRecommendation = new RecommendationSummary
		                {
		                    Rank = 1,
                            Discount1 = 10
		                }
		            },
		            new RecommendationProductSummary
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                ProductId = 2222,
                        ProductName = "ProductName2",
                        DecisionRecommendation = new RecommendationSummary
		                {
		                    Rank = 1,
		                    Discount1 = 20
                        }
		            },
		            new RecommendationProductSummary
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                ProductId = 333,
                        ProductName = "ProductName3",
                        DecisionRecommendation = new RecommendationSummary
		                {
		                    Rank = 1,
		                    Discount1 = 30
                        }
		            },
		            new RecommendationProductSummary
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                ProductId = 444,
		                ProductName = "ProductName4",
                        DecisionRecommendation = new RecommendationSummary
		                {
		                    Rank = 1,
		                    Discount1 = 40
                        }
                    },
		            new RecommendationProductSummary
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                ProductId = 555,
		                ProductName = "ProductName5",
		                DecisionRecommendation = new RecommendationSummary
		                {
		                    Rank = 1,
		                    Discount1 = 50
                        }
		            },
		            new RecommendationProductSummary
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                ProductId = 555,
		                ProductName = "Matt",
		                DecisionRecommendation = new RecommendationSummary
		                {
		                    Rank = 1,
		                    Discount1 = 60
                        }
		            }
                }.AsQueryable()));

		    _mockDbContext
		        .Setup(context => context.RecommendationProjections)
		        .ReturnsDbSet(new TestAsyncEnumerable<RecommendationProjection>(new List<RecommendationProjection>
		        {
		            new RecommendationProjection
		            {
		                ClientId = 123,
		                ScenarioId = 100,
                        Week = 100
		            },
		            new RecommendationProjection
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                Week = 101
                    },
		            new RecommendationProjection
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                Week = 102
		            },
		            new RecommendationProjection
		            {
		                ClientId = 123,
		                ScenarioId = 100,
		                Week = 103
		            },
                }.AsQueryable()));

			_mockDbContextFactory
                .Setup(mockFactory => mockFactory.Create(It.IsAny<DbContextFactoryOptions>()))
				.Returns(_mockDbContext.Object);
		}

		[Fact]
		public async void GetAll_QueryResults_ItemsLength_IsLessOrEquals_PageSize()
		{
			var recommendationRepository = new RecommendationProductSummaryRepository(_mockDbContextFactory.Object);

			var scenarioId = 100;
			var pageSize = 2;
			var pageIndex = 1;
			var filters = new List<IFilter>();

			var results = await recommendationRepository.GetAll(scenarioId, pageIndex, pageSize, filters, null);
			Assert.Equal(results.Items.Count, results.PageSize);

			var scenarioId2 = 100;
			var pageSize2 = 10;
			var pageIndex2 = 1;
			var filters2 = new List<IFilter>();

			var results2 = await recommendationRepository.GetAll(scenarioId2, pageIndex2, pageSize2, filters2, null);
			Assert.True(results2.Items.Count <= results2.PageSize);
		}

		[Fact]
		public async void GetAll_Can_Skip_Pages()
		{
		    var expected = "ProductName5";

            var scenarioId = 100;
			var pageSize = 2;
			var pageIndex = 3;
			var filters = new List<IFilter>();

		    var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
		        .GetAll(scenarioId, pageIndex, pageSize, filters, null);

            result.Items.Should().NotBeEmpty();
		    result.Items.First().ProductName.Should().Be(expected);
        }

		[Fact]
		public async void GetAll_Eq_Matches_A_Product_Name()
		{
		    var expected = "ProductName1";

            var scenarioId = 100;
			var pageSize = 1;
			var pageIndex = 1;

		    var filters = new List<IFilter>
		    {
		        new Filter {Key = "ProductName", Op = FilterOperator.Eq, Value = "ProductName1"}
		    };

		    var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
		        .GetAll(scenarioId, pageIndex, pageSize, filters, null);

            result.Items.Should().NotBeEmpty();
		    result.Items.First().ProductName.Should().Be(expected);
        }

	    [Fact]
	    public async void GetAll_Eq_Matches_A_Discount()
	    {
	        var discount = 30M;
	        var expected = "ProductName3";

	        var scenarioId = 100;
	        var pageSize = 1;
	        var pageIndex = 1;

	        var filters = new List<IFilter>
	        {
	            new Filter {Key = "Discount1", Op = FilterOperator.Eq, Value = discount}
	        };

	        var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
	            .GetAll(scenarioId, pageIndex, pageSize, filters, null);

	        result.Items.Should().NotBeEmpty();
	        result.Items.First().ProductName.Should().Be(expected);
	    }

        [Fact]
	    public async void GetAll_Eq_Does_Not_Match_A_Product_Name()
	    {
	        var scenarioId = 100;
	        var pageSize = 1;
	        var pageIndex = 1;

	        var filters = new List<IFilter>
	        {
	            new Filter { Key = "ProductName", Op = FilterOperator.Eq, Value = "DoesNotExist" }
            };

            var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
                .GetAll(scenarioId, pageIndex, pageSize, filters, null);

	        result.Items.Should().BeEmpty();
	    }

        [Fact]
		public async void GetAll_Inc_Matches_Product_Name()
		{
			var scenarioId = 100;
			var pageSize = 20;
			var pageIndex = 1;

		    var filters = new List<IFilter>
		    {
		        new Filter {Key = "ProductName", Op = FilterOperator.Inc, Value = "ProductName"}
		    };

		    var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
		        .GetAll(scenarioId, pageIndex, pageSize, filters, null);

            Assert.True(result.Items.Count == 5);
		}

		[Fact]
		public async void GetAll_Not_Inc_Ignores_Other_Product_Names()
		{
		    var expected = "Matt";

			var scenarioId = 100;
			var pageSize = 20;
			var pageIndex = 1;

		    var filters = new List<IFilter>
		    {
		        new Filter {Key = "ProductName", Op = FilterOperator.Ninc, Value = "ProductName"}
		    };

		    var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
		        .GetAll(scenarioId, pageIndex, pageSize, filters, null);

		    result.Items.Should().NotBeEmpty();
		    result.Items.First().ProductName.Should().Be(expected);
        }

		[Fact]
		public async void GetAll_Starts_With_Matches_Product_Names()
		{
			var scenarioId = 100;
			var pageSize = 20;
			var pageIndex = 1;

		    var filters = new List<IFilter> {new Filter {Key = "ProductName", Op = FilterOperator.Sw, Value = "Product"}};

		    var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
		        .GetAll(scenarioId, pageIndex, pageSize, filters, null);

		    result.Items.Should().NotBeEmpty();
		    result.Items.Count.Should().Be(5);
		}

		[Fact]
		public async void GetAll_Ends_With_Matches_Product_Name()
		{
		    var expected = "ProductName1";

			var scenarioId = 100;
			var pageSize = 20;
			var pageIndex = 1;

		    var filters = new List<IFilter> {new Filter {Key = "ProductName", Op = FilterOperator.Ew, Value = "1"}};

		    var result = await new RecommendationProductSummaryRepository(_mockDbContextFactory.Object)
		        .GetAll(scenarioId, pageIndex, pageSize, filters, null);

		    result.Items.Should().NotBeEmpty();
		    result.Items.First().ProductName.Should().Be(expected);
        }
	}
}

