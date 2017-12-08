using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading;
using Markdown.Data.Entity.App;
using Markdown.Service;
using Markdown.Service.Models;
using Markdown.WebApi.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Authentication;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.Extensions.Logging;
using Moq;
using Serilog.Core;
using Xunit;

namespace Markdown.WebApi.Tests
{
    public class ServerAuthorizationHandlerTests
    {
        
		[Fact]
		public async void HandleRequirementAsync_WillNotSucceed_WhenUser_DoesNotHavePermission()
		{
            var mockAccessControlService = new Mock<IAccessControlService>();
            var mockLoggerFactory = new Mock<ILoggerFactory>();

			//GetAll here returns no permissions for this user, user needs MKD_SCENARIO_CREATE to meet the requirement.
            mockAccessControlService.Setup(x=>x.GetAll(It.IsAny<string>())).Returns(new SmOrganisationData() {Permissions = new List<SmPermission>()});
            mockLoggerFactory.Setup(x => x.CreateLogger(It.IsAny<string>())).Returns(new Mocklogger());

            var user = new ClaimsPrincipal(new ClaimsIdentity(new List<Claim> { new Claim(ClaimTypes.Email, "ciamckenna@deloitte.co.uk") }));
            var requirement = new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_CREATE);

			var filterContext = new AuthorizationFilterContext(
			   new Microsoft.AspNetCore.Mvc.ActionContext(new MockHttpContext { },
														  new Microsoft.AspNetCore.Routing.RouteData { },
														  new Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor())
												   , new List<IFilterMetadata> { });
            
			var authzContext = new AuthorizationHandlerContext(new List<IAuthorizationRequirement> { requirement }, user, filterContext);

            var authzHandler = new ServerAuthorizationHandler( mockLoggerFactory.Object,mockAccessControlService.Object);
            await authzHandler.HandleAsync(authzContext);

			Assert.False(authzContext.HasSucceeded);
		}

		[Fact]
		public async void HandleRequirementAsync_WillNotSucceed_When_EmailClaim_IsNotPresent()
		{
			var mockAccessControlService = new Mock<IAccessControlService>();
			var mockLoggerFactory = new Mock<ILoggerFactory>();

			//GetAll here returns no permissions for this user, user needs MKD_SCENARIO_CREATE to meet the requirement.
			mockAccessControlService.Setup(x => x.GetAll(It.IsAny<string>())).Returns(new SmOrganisationData() { });
			mockLoggerFactory.Setup(x => x.CreateLogger(It.IsAny<string>())).Returns(new Mocklogger());

            var user = new ClaimsPrincipal(new ClaimsIdentity(new List<Claim> { }));
			var requirement = new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_CREATE);

			var authzContext = new AuthorizationHandlerContext(new List<IAuthorizationRequirement> { requirement }, user, null);

			var authzHandler = new ServerAuthorizationHandler(mockLoggerFactory.Object, mockAccessControlService.Object);
			await authzHandler.HandleAsync(authzContext);

			Assert.False(authzContext.HasSucceeded);
		}

		[Fact]
		public async void HandleRequirementAsync_WillSucceed_When_EmailClaim_IsPresent_And_UserHasPermission()
		{
			var mockAccessControlService = new Mock<IAccessControlService>();
			var mockLoggerFactory = new Mock<ILoggerFactory>();

			//GetAll here returns no permissions for this user, user needs MKD_SCENARIO_CREATE to meet the requirement.
			mockAccessControlService.Setup(x => x.GetAll(It.IsAny<string>())).Returns(
               new SmOrganisationData  {
                Permissions= new List<SmPermission>(){ new SmPermission { PermissionCode = Policies.MKD_SCENARIO_CREATE } }
                }
            );

			mockLoggerFactory.Setup(x => x.CreateLogger(It.IsAny<string>())).Returns(new Mocklogger());

			var user = new ClaimsPrincipal(new ClaimsIdentity(new List<Claim> { new Claim(ClaimTypes.Email, "ciamckenna@deloitte.co.uk") }));
			var requirement = new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_CREATE);

            var filterContext = new AuthorizationFilterContext(
                new Microsoft.AspNetCore.Mvc.ActionContext(new MockHttpContext { },
                                                           new Microsoft.AspNetCore.Routing.RouteData{},
                                                           new Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor())
                                                    ,new List<IFilterMetadata>{});

            var authzContext = new AuthorizationHandlerContext(new List<IAuthorizationRequirement> { requirement }, 
                                                               user, 
                                                               filterContext);

			var authzHandler = new ServerAuthorizationHandler(mockLoggerFactory.Object, mockAccessControlService.Object);
			await authzHandler.HandleAsync(authzContext);

            Assert.True(authzContext.HasSucceeded);
		}

		[Fact]
		public async void HandleRequirementAsync_WillNotSucceed_When_EmailAddress_IsNotValid()
		{
			var mockAccessControlService = new Mock<IAccessControlService>();
			var mockLoggerFactory = new Mock<ILoggerFactory>();

			//GetAll here returns no permissions for this user, user needs MKD_SCENARIO_CREATE to meet the requirement.
			mockAccessControlService.Setup(x => x.GetAll(It.IsAny<string>())).Returns(
				 new SmOrganisationData
				 {
					 Permissions = new List<SmPermission>() { new SmPermission { PermissionCode = Policies.MKD_SCENARIO_CREATE } }
				 }
			);

			mockLoggerFactory.Setup(x => x.CreateLogger(It.IsAny<string>())).Returns(new Mocklogger());

			var user = new ClaimsPrincipal(new ClaimsIdentity(new List<Claim> { new Claim(ClaimTypes.Email, "invalidEmailString") }));
			var requirement = new ServerAuthorizationRequirement(Policies.MKD_SCENARIO_CREATE);

			var authzContext = new AuthorizationHandlerContext(new List<IAuthorizationRequirement> { requirement }, user, null);

			var authzHandler = new ServerAuthorizationHandler(mockLoggerFactory.Object, mockAccessControlService.Object);
			await authzHandler.HandleAsync(authzContext);

            Assert.False(authzContext.HasSucceeded);
		}
    }



    public class Mocklogger : ILogger
    {
        public IDisposable BeginScope<TState>(TState state)
        {
            throw new NotImplementedException();
        }

        public bool IsEnabled(LogLevel logLevel)
        {
            return true;
        }

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
        {
            
        }
    }

    public class MockHttpContext : HttpContext
    {
        public override IFeatureCollection Features => throw new NotImplementedException();

        public override HttpRequest Request => throw new NotImplementedException();

        public override HttpResponse Response => throw new NotImplementedException();

        public override ConnectionInfo Connection => throw new NotImplementedException();

        public override WebSocketManager WebSockets => throw new NotImplementedException();

        public override AuthenticationManager Authentication => throw new NotImplementedException();

        public override ClaimsPrincipal User { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override IDictionary<object, object> Items { get => new Dictionary<object, object>(); set => throw new NotImplementedException(); }
        public override IServiceProvider RequestServices { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override CancellationToken RequestAborted { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override string TraceIdentifier { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override ISession Session { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public override void Abort()
        {
            throw new NotImplementedException();
        }
    }

}
