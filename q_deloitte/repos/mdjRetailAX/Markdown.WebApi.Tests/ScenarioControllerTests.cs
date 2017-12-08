using System.Net;

using Moq;
using Xunit;
using FluentAssertions;

using Markdown.Common.Enums;
using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef;
using Markdown.Service;
using Markdown.WebApi.Controllers;
using Markdown.WebApi.Models;
using RetailAnalytics.Data;
using System.Collections.Generic;

namespace Markdown.WebApi.Tests
{
    public class ScenarioControllerTests
    {
		private readonly Mock<IHierarchyService> _hierarchyServiceMock;
		private readonly Mock<IScenarioWebService> _scenarioWebServiceMock;
		private readonly Mock<IRecommendationProductService> _recommendationServiceMock;
        private readonly Mock<IFileUploadService> _fileUploadServiceMock;
        private readonly Mock<IOrganisationDataProvider> _organisationDataProvider;

        public ScenarioControllerTests()
        {
            _hierarchyServiceMock = new Mock<IHierarchyService>();
            _scenarioWebServiceMock = new Mock<IScenarioWebService>();
            _recommendationServiceMock = new Mock<IRecommendationProductService>();
            _fileUploadServiceMock = new Mock<IFileUploadService>();
            _organisationDataProvider = new Mock<IOrganisationDataProvider>();

            _organisationDataProvider.Setup(Organisation=>Organisation.ScenarioIds).Returns(new List<int>{100});
		}

		[Fact]
		public void GetAll_ThrowsBadRequest_IfFilterOperatorIsNotSupported()
		{
            var scenarioController = new ScenarioController(_hierarchyServiceMock.Object,
                                                            _scenarioWebServiceMock.Object,
                                                            _recommendationServiceMock.Object, 
                                                            _fileUploadServiceMock.Object,
                                                            _organisationDataProvider.Object);

            var scenarioSummaryParams = new ScenarioSummaryApiParams { ProductCount="opThatIsn'tSupported:234"};

           var response= scenarioController.GetAll(scenarioSummaryParams);

            var httpStatusCodeException = (ErrorHandlerMiddleware.HttpStatusCodeException)response.Exception.InnerException;

            Assert.Equal(HttpStatusCode.BadRequest,httpStatusCodeException.StatusCode);
          
		}

        [Fact]
        public void GetAll_ThrowsBadRequest_IfNonEpochIsEnteredForDateTimeField()
		{
			var scenarioController = new ScenarioController(_hierarchyServiceMock.Object,
															_scenarioWebServiceMock.Object,
															_recommendationServiceMock.Object,
			                                                _fileUploadServiceMock.Object,
															_organisationDataProvider.Object);

			var scenarioSummaryParamsLt = new ScenarioSummaryApiParams { LastRunDate = "Lt:randomChars" };
			var responseLt = scenarioController.GetAll(scenarioSummaryParamsLt);

			var httpStatusCodeExceptionLt = (ErrorHandlerMiddleware.HttpStatusCodeException)responseLt.Exception.InnerException;

			Assert.Equal(HttpStatusCode.BadRequest, httpStatusCodeExceptionLt.StatusCode);
		}

		[Fact]
		public void GetAll_Throws_BadRequest_IfStringIsEnteredForIntegerField()
		{
			var scenarioController = new ScenarioController(_hierarchyServiceMock.Object,
															_scenarioWebServiceMock.Object,
															_recommendationServiceMock.Object,
                                                            _fileUploadServiceMock.Object,
                                                            _organisationDataProvider.Object);

			var scenarioSummaryParams = new ScenarioSummaryApiParams { ProductCount = "Gt:randomString" };

			var response = scenarioController.GetAll(scenarioSummaryParams);

			var httpStatusCodeException = (ErrorHandlerMiddleware.HttpStatusCodeException)response.Exception.InnerException;

			Assert.Equal(HttpStatusCode.BadRequest, httpStatusCodeException.StatusCode);

		}

		[Fact]
		public void GetAll_ThrowsBadRequest_IfDecimalIsEnteredForIntegerField()
		{
			var scenarioController = new ScenarioController(_hierarchyServiceMock.Object,
															_scenarioWebServiceMock.Object,
															_recommendationServiceMock.Object,
			                                                 _fileUploadServiceMock.Object,
                                                            _organisationDataProvider.Object);

			var scenarioSummaryParams = new ScenarioSummaryApiParams { ProductCount = "Gt:1.23344" };

			var response = scenarioController.GetAll(scenarioSummaryParams);

			var httpStatusCodeException = (ErrorHandlerMiddleware.HttpStatusCodeException)response.Exception.InnerException;

			Assert.Equal(HttpStatusCode.BadRequest, httpStatusCodeException.StatusCode);

		}

		[Fact]
		public void GetAll_ThrowsBadRequest_IfStringIsEnteredForDoubleField()
		{
			var scenarioController = new ScenarioController(_hierarchyServiceMock.Object,
															_scenarioWebServiceMock.Object,
															_recommendationServiceMock.Object,
                                                            _fileUploadServiceMock.Object,
                                                            _organisationDataProvider.Object);

            var scenarioSummaryParams = new ScenarioSummaryApiParams { Duration = "Gt:sssss" };

			var response = scenarioController.GetAll(scenarioSummaryParams);

			var httpStatusCodeException = (ErrorHandlerMiddleware.HttpStatusCodeException)response.Exception.InnerException;

			Assert.Equal(HttpStatusCode.BadRequest, httpStatusCodeException.StatusCode);

		}

        [Fact]
        public void GetReturnsNewPartitionScenarioSummary()
        {
            // Arrange
            var scenarioEntity = new Scenario
            {
                ScenarioId = 100,
                ScenarioName = "ScenarioName",
                OrganisationId = 111,
                Week = 100,
                ScheduleMask = 255,
                ScheduleWeekMin = 100,
                ScheduleWeekMax = 107,
                ScheduleStageMin = 1,
                ScheduleStageMax = 4,
                StageMax = 4,
                StageOffsetMax = 8,
                PriceFloor = null,
                MarkdownCountStartWeek = 800,
                DefaultMarkdownType = 255,
                AllowPromoAsMarkdown = false,
                MinimumPromoPercentage = 0M
            };

            var summaryEntity = new ScenarioSummary
            {
                Scenario = scenarioEntity,
                ScenarioId = scenarioEntity.ScenarioId,
                ScenarioName = scenarioEntity.ScenarioName,
                Duration = 0,
                ErrorCount = 0,
                RecommendationCount = 0,
                ProductCount = 2,
                LastRunDate = null,
                SuccessCount = 0,
                ProductTotal = 0,
                AttemptCountAvg = 0,
                AttemptCountMax = 0,
                AttemptCountMin = 0,
                LastFunctionInstanceId = null,
                FunctionInstanceCount = 1,
                FunctionInstanceCountTotal = 1,
                LastGroupTypeId = (int)Common.Enums.FunctionGroupType.Partition,
                LastGroupTypeName = Common.Enums.FunctionGroupType.Partition.ToString(),
                ScenarioSummaryStatusTypeName = ScenarioSummaryStatusType.New.ToString(),
                ScenarioSummaryStatusTypeId = ScenarioSummaryStatusType.New
            };

            var expected = new VmScenarioSummary
            {
                CustomerId = scenarioEntity.OrganisationId,
                ScenarioId = scenarioEntity.ScenarioId,
                ScenarioName = scenarioEntity.ScenarioName,

                Status = ScenarioSummaryStatusType.New,
                Duration = summaryEntity.Duration,
                PartitionErrorCount = summaryEntity.ErrorCount,
                PartitionSuccessCount = summaryEntity.SuccessCount,
                PartitionCount = summaryEntity.FunctionInstanceCount,
                PartitionTotal = summaryEntity.FunctionInstanceCountTotal,
                LastRunDate = summaryEntity.LastRunDate,
                RecommendationCount = summaryEntity.RecommendationCount,
                TotalNumberRecommendedProducts = summaryEntity.ProductCount,
                PriceFloor = scenarioEntity.PriceFloor,

                Week = scenarioEntity.Week,
                ScheduleMask = scenarioEntity.ScheduleMask,
                StageMax = scenarioEntity.StageMax,
                StageOffsetMax = scenarioEntity.StageOffsetMax,
                ScheduleWeekMin = scenarioEntity.ScheduleWeekMin,
                ScheduleWeekMax = scenarioEntity.ScheduleWeekMax,
                ScheduleStageMin = scenarioEntity.ScheduleStageMin,
                ScheduleStageMax = scenarioEntity.ScheduleStageMax,
                MarkdownCountStartWeek = scenarioEntity.MarkdownCountStartWeek
            };

            var scenarioRepository = new Mock<IScenarioRepository>();
            var scenarioSummaryRepository = new Mock<IScenarioSummaryRepository>();
            var scenarioHierarchyFilterRepository = new Mock<IScenarioHierarchyFilterRepository>();
            var scenarioProductFilterRepository = new Mock<IScenarioProductFilterRepository>();

            var scenarioWebService = new ScenarioWebService(scenarioRepository.Object, scenarioSummaryRepository.Object, scenarioProductFilterRepository.Object, scenarioHierarchyFilterRepository.Object);
            scenarioSummaryRepository.Setup(x => x.GetSingle(scenarioEntity.OrganisationId, scenarioEntity.ScenarioId)).ReturnsAsync(summaryEntity);

            var scenarioController = new ScenarioController(_hierarchyServiceMock.Object, scenarioWebService, _recommendationServiceMock.Object, _fileUploadServiceMock.Object, _organisationDataProvider.Object);

            // Act
            var actual = scenarioController.Get(scenarioEntity.ScenarioId,scenarioEntity.OrganisationId ).Result;

            // Assert
            actual.ShouldBeEquivalentTo(expected);
        }
    }
}
