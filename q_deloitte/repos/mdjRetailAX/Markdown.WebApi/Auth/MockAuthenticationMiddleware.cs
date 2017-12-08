using System;
using System.Collections.Generic;
using System.Text.Encodings.Web;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Authentication;
using Microsoft.AspNetCore.Http.Features.Authentication;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace Markdown.WebApi.Auth
{
	public static class MockAuthenticationExtension
	{
		public static IApplicationBuilder UseAuthentication(this IApplicationBuilder app, 
                                                                JwtBearerOptions options,
                                                                bool IsDevelopment, 
                                                                IConfigurationRoot configuration )
		{
			if (app == null)
			{
				throw new ArgumentNullException(nameof(app));
			}

            return app.UserJwtBearerAuthentication(configuration);
		}
	}

	public class MockAuthenticationHandler : AuthenticationHandler<JwtBearerOptions>
	{
		/// <summary>
		/// Searches the 'Authorization' header for a 'Bearer' token. If the 'Bearer' token is found, it is validated using <see cref="TokenValidationParameters"/> set in the options.
		/// </summary>
		/// <returns></returns>
		protected override Task<AuthenticateResult> HandleAuthenticateAsync()
		{
			var ticket = new AuthenticationTicket(new System.Security.Claims.ClaimsPrincipal(), new AuthenticationProperties(), Options.AuthenticationScheme);

			return Task.FromResult(AuthenticateResult.Success(ticket));
		}

		protected override Task<bool> HandleUnauthorizedAsync(ChallengeContext context)
		{
			return Task.FromResult(false);
		}

		private static string CreateErrorDescription(Exception authFailure)
		{
			IEnumerable<Exception> exceptions;
			if (authFailure is AggregateException)
			{
				var agEx = authFailure as AggregateException;
				exceptions = agEx.InnerExceptions;
			}
			else
			{
				exceptions = new[] { authFailure };
			}

			var messages = new List<string>();

			foreach (var ex in exceptions)
			{

			}

			return string.Join("; ", messages);
		}

		protected override Task HandleSignOutAsync(SignOutContext context)
		{
			throw new NotSupportedException();
		}

		protected override Task HandleSignInAsync(SignInContext context)
		{
			throw new NotSupportedException();
		}
	}


	public class MockAuthenticationMiddleware : AuthenticationMiddleware<JwtBearerOptions>
	{
		public MockAuthenticationMiddleware(
			RequestDelegate next,
			ILoggerFactory loggerFactory,
			UrlEncoder encoder,
			IOptions<JwtBearerOptions> options)
				: base(next, options, loggerFactory, encoder)
		{

		}

		protected override AuthenticationHandler<JwtBearerOptions> CreateHandler()
		{
			return new MockAuthenticationHandler();
		}

	}
}
