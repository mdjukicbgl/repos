﻿﻿using System;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace Markdown.WebApi.Auth
{
	public static class Startup
	{
		public static IApplicationBuilder UserJwtBearerAuthentication(this IApplicationBuilder app, IConfigurationRoot Configuration)
		{
			var tokenParameters = Configuration.GetSection("TokenParameters");

			var tokenValidationParameters = new TokenValidationParameters
			{
				// Validate the JWT Issuer (iss) claim
				ValidateIssuer = true,
				ValidIssuer = tokenParameters["Issuer"],

				// Validate the JWT Audience (aud) claim
				ValidateAudience = true,
				ValidAudience = tokenParameters["Audience"],

				// Validate the token expiry,
				ValidateLifetime = true,

				// If you want to allow a certain amount of clock drift, set that here:
				ClockSkew = TimeSpan.Zero
			};

           var jwtBearerOptions = new JwtBearerOptions
            {
                Authority = tokenParameters["Authority"],
                AutomaticAuthenticate = true,
                AutomaticChallenge = true,
                MetadataAddress = tokenParameters["MetadataAddress"],
                TokenValidationParameters = tokenValidationParameters,
                Events = new CustomBearerEvents()
            };

			app.UseJwtBearerAuthentication(jwtBearerOptions);

            return app;
		}

	}
}