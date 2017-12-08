using System;
using System.Collections.Generic;
using Amazon.Lambda.Core;
using Microsoft.Extensions.Configuration;

namespace Markdown.Common.Settings
{
    public interface IWebApiSettings : ICommonSettings
    {
        List<string> CorsOrigins { get; set; }
        string LambdaFunctionName { get; set; }
    }

    public class WebApiSettings : CommonSettings, IWebApiSettings
    {
        public List<string> CorsOrigins { get; set; } = new List<string> { "http://localhost:4200" };
        public string LambdaFunctionName { get; set; }

        public WebApiSettings(IConfiguration configuration, ILambdaContext context = null) : base(configuration, context)
        {
            var settings = configuration.GetSection("Settings");

            // API SDK settings
            var lambdaFunctionName = configuration["LambdaFunctionName"] ?? settings["LambdaFunctionName"];
            if (string.IsNullOrWhiteSpace(lambdaFunctionName))
                throw new Exception("Missing LambdaFunctionName in configuration");
            LambdaFunctionName = lambdaFunctionName;

            // CORS
            var corsOrigin = configuration["CorsOrigin"] ?? settings["CorsOrigin"];
            if (string.IsNullOrWhiteSpace(corsOrigin))
                throw new Exception("Missing CorsOrigin in configuration");
            CorsOrigins.AddRange(corsOrigin.Split(','));
        }
    }
}