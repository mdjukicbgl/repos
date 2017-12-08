﻿﻿﻿using System;
using System.Diagnostics;
using System.Collections.Generic;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.ViewComponents;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

using Amazon.S3;
using Amazon.Lambda;
 using Amazon.CloudWatchLogs;

using Serilog;
using Serilog.Core;
using Serilog.Sinks.AwsCloudWatch;
using Newtonsoft.Json.Converters;
using Swashbuckle.AspNetCore.Swagger;

using ILogger = Serilog.ILogger;

using SimpleInjector;
using SimpleInjector.Integration.AspNetCore.Mvc;
using SimpleInjector.Lifestyles;

using RetailAnalytics.Data;

using Markdown.Data;
using Markdown.Common.Clients;
using Markdown.Common.Settings;
using Markdown.Common.Settings.Interfaces;
using Microsoft.Extensions.Caching.Memory;
using Markdown.WebApi.Auth;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;

namespace Markdown.WebApi
{
    public class Startup
    {
        private readonly Container _container = new Container();

        private readonly Logger _logger;
        private readonly IWebApiSettings _settings;
        private readonly IFileUploadSettings _fileUploadSettings;

        private readonly IAmazonS3 _s3Client;
        private readonly IAmazonLambda _lambdaClient;
        private readonly IAmazonCloudWatchLogs _cloudWatchClient;

        public IHostingEnvironment HostingEnvironment { get; }
        public IConfigurationRoot Configuration { get; }

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appSettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile("appSettings." + env.EnvironmentName + ".json", optional: true, reloadOnChange: true)
                .AddEnvironmentVariables();
            Configuration = builder.Build();

			HostingEnvironment = env;

			// Serilog
			Serilog.Debugging.SelfLog.Enable(x => Debug.WriteLine(x));
            var awsOptions = Configuration.GetAWSOptions();

            // AWS clients
            _s3Client = awsOptions.CreateServiceClient<IAmazonS3>();
            _lambdaClient = awsOptions.CreateServiceClient<IAmazonLambda>();
            _cloudWatchClient = awsOptions.CreateServiceClient<IAmazonCloudWatchLogs>();

            _logger = new LoggerConfiguration()
                .ReadFrom.Configuration(Configuration)
                .WriteTo.AmazonCloudWatch(new CloudWatchSinkOptions { LogGroupName = "markdown-webapi", Period = TimeSpan.FromSeconds(5) }, _cloudWatchClient)
                .CreateLogger();

            _logger.Information("Server started: HostingEnvironment: {@HostingEvironment}", env);
            _logger.Information("Server started: Environment: {@Environment}", Environment.GetEnvironmentVariables());
            _logger.Information("Server started: Configuration: {@Configuration}", Configuration.AsEnumerable());

            _settings = new WebApiSettings(Configuration);
            _fileUploadSettings = new FileUploadSettings(Configuration);
        }

        // This method gets called by the runtime.
        public void ConfigureServices(IServiceCollection services)
        {
            // ASP.NET default stuff here
            services
                .AddMvc()
                .AddJsonOptions(options =>
                {
                    options.SerializerSettings.Converters.Add(new StringEnumConverter { CamelCaseText = false });
                });

			services.AddScoped<IDbConnectionProvider, DbConnectionProvider>();

            services.AddAuthorizationPolicies(HostingEnvironment.IsDevelopment());
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddOrganisationDataProvider(HostingEnvironment.IsDevelopment());

			services.AddSingleton<ILogger>(_logger);
            services.AddSingleton<ISqlSettings>(_settings);
            services.AddSingleton<IControllerActivator>(new SimpleInjectorControllerActivator(_container));
            services.AddSingleton<IViewComponentActivator>(new SimpleInjectorViewComponentActivator(_container));
            services.UseSimpleInjectorAspNetRequestScoping(_container);

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info { Title = "Markdown API", Version = "v1" });

                c.DescribeAllEnumsAsStrings();
                c.DescribeStringEnumsInCamelCase();
                c.DescribeAllParametersInCamelCase();
            });

			Service.Startup.RegisterServicesDependancies(services);
        }

        // Configure is called after ConfigureServices is called.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory, IApplicationLifetime appLifetime)
        {
            // .NET Core logging
            loggerFactory.AddSerilog(_logger);

            // Ensure any buffered events are sent at shutdown
            appLifetime.ApplicationStopped.Register(Log.CloseAndFlush);
    
            app.UseErrorHandlerMiddleware();

            app.UseAuthentication(new JwtBearerOptions { AuthenticationScheme = "Dummy" },
                                    HostingEnvironment.IsDevelopment(),
                                    Configuration);

            // Dependency injection
            RegisterDependencies(app);

            // .NET Core
            app.UseCors(builder => builder
                .WithOrigins(_settings.CorsOrigins.ToArray())
                .AllowAnyHeader()
                .AllowAnyMethod()
                .AllowCredentials());

            app.UseMvc(routes => routes.MapRoute("default", "{controller=Home}/{action=Index}/{id?}"));
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Markdown API V1");
            });

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
        }

        private void RegisterDependencies(IApplicationBuilder app)
        {
            _container.Options.DefaultScopedLifestyle = new AsyncScopedLifestyle();

            // Singletons
            _container.RegisterSingleton<ILogger>(_logger);
            _container.RegisterSingleton(app.ApplicationServices.GetService<ILoggerFactory>());
            _container.RegisterSingleton(_s3Client);
            _container.RegisterSingleton<IMemoryCache>(new MemoryCache(new MemoryCacheOptions()));
            _container.RegisterSingleton<IMarkdownClient>(new MarkdownAwsSdkClient(_lambdaClient, _settings.LambdaFunctionName));

            _container.RegisterSingleton(_settings);
            _container.RegisterSingleton(_fileUploadSettings);
            _container.RegisterSingleton<ICommonSettings>(_settings);
            _container.RegisterSingleton<IS3Settings>(_settings);
            _container.RegisterSingleton<ISqlSettings>(_settings);
            _container.RegisterSingleton<ICloudWatchSettings>(_settings);

            // Scoped
            _container.Register<IMarkdownSqlContext, MarkdownSqlContext>(Lifestyle.Scoped);
            _container.Register<IDbConnectionProvider, DbConnectionProvider>(Lifestyle.Scoped);
			_container.RegisterSingleton(app.ApplicationServices.GetService<IHttpContextAccessor>());
            _container.RegisterOrganisationDataProvider(HostingEnvironment.IsDevelopment());

            // MVC
            _container.RegisterMvcControllers(app);
            _container.RegisterMvcViewComponents(app);

            // The following registers a Func<T> delegate that can be injected as singleton, and on invocation resolves a MVC IViewBufferScope service for that request.
            //  _container.RegisterSingleton<Func<IViewBufferScope>>(app.GetRequestService<IViewBufferScope>);

            Service.Startup.RegisterDependanciesWeb(_container);
            _container.Verify();
        }
    }
}
