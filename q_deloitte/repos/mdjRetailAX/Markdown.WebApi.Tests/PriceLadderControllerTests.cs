using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using FluentAssertions;
using Markdown.Data.Entity.App;
using Markdown.Data.Repository.Ef;
using Markdown.Service;
using Markdown.WebApi.Controllers;
using Markdown.WebApi.Models;
using Moq;
using Xunit;

namespace Markdown.WebApi.Tests
{
    public class PriceLadderControllerTests
    {
        [Fact]
        public void Get_Throws_Not_Found_Exception()
        {
            var priceLadderRepository = new Mock<IPriceLadderRepository>();
            var service = new PriceLadderService(priceLadderRepository.Object);
            var controller = new PriceLadderController(service);

            var expected = HttpStatusCode.NotFound;

            Func<Task> act = async () => await controller.Get(123);

            act.ShouldThrow<ErrorHandlerMiddleware.HttpStatusCodeException>()
                .And.StatusCode.Should().Be(expected);
        }

        [Fact]
        public async Task Get_Returns_Price_Ladder()
        {
            var priceLadderRepository = new Mock<IPriceLadderRepository>();
            var service = new PriceLadderService(priceLadderRepository.Object);
            var controller = new PriceLadderController(service);

            var priceLadderType = new PriceLadderType
            {
                PriceLadderTypeId = 22,
                Description = "PriceLadderTypeDescription"
            };

            var entity = new PriceLadder
            {
                PriceLadderId = 42,
                PriceLadderTypeId = priceLadderType.PriceLadderTypeId,
                PriceLadderType = priceLadderType,
                Description = "Description",
            };

            entity.Values.Add(new PriceLadderValue
            {
                PriceLadderValueId = 1,
                PriceLadder = entity,
                PriceLadderId = entity.PriceLadderId,
                Order = 1,
                Value = 0.1M
            });

            entity.Values.Add(new PriceLadderValue
            {
                PriceLadderValueId = 1,
                PriceLadder = entity,
                PriceLadderId = entity.PriceLadderId,
                Order = 2,
                Value = 0.2M
            });

            entity.Values.Add(new PriceLadderValue
            {
                PriceLadderValueId = 1,
                PriceLadder = entity,
                PriceLadderId = entity.PriceLadderId,
                Order = 3,
                Value = 0.3M
            });

            priceLadderRepository
                .Setup(x => x.GetById(entity.PriceLadderId))
                .ReturnsAsync(entity);

            var expected = new VmPriceLadder
            {
                PriceLadderId = 42,
                Description = "Description",
                PriceLadderTypeId = 22,
                Values = new List<decimal> {0.1M, 0.2M, 0.3M}
            };

            var result = await controller.Get(entity.PriceLadderId);

            result.ShouldBeEquivalentTo(expected);
        }
    }
}