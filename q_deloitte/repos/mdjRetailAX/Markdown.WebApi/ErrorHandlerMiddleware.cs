using System;
using System.Net;
using System.Collections;
using System.Diagnostics;
using System.Threading.Tasks;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Logging;

using Newtonsoft.Json;

namespace Markdown.WebApi
{
    public static class ErrorMiddlewareExtensions
    {
        public static IApplicationBuilder UseErrorHandlerMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<ErrorHandlerMiddleware>();
        }
    }

    public class ErrorHandlerMiddleware
    {
#if DEBUG
        public const bool IsDebug = true;
#else
        public const bool IsDebug = false;
#endif

        public class ErrorModel
        {
            public int HttpStatusCode { get; set; }
            public string HttpStatusCodeName { get; set; }
            public string Message { get; set; }
            //public IEnumerable Errors { get; set; }

            public static ErrorModel FromException(HttpStatusCodeException ex)
            {
                return new ErrorModel
                {
                    Message = ex.Message,
                   // Errors = ex.Errors,
                    HttpStatusCode = (int) ex.StatusCode,
                    HttpStatusCodeName = ex.StatusCode.ToString()
                };
            }
        }

        public class HttpStatusCodeException : Exception
        {
            public IEnumerable Errors { get; set; }
            public HttpStatusCode StatusCode { get; set; }

            public HttpStatusCodeException(HttpStatusCode statusCode)
            {
                StatusCode = statusCode;
            }

            public HttpStatusCodeException(HttpStatusCode statusCode, string message) : base(message)
            {
                StatusCode = statusCode;
            }

            public HttpStatusCodeException(HttpStatusCode statusCode, IEnumerable errors) : base("Several errors occured")
            {
                StatusCode = statusCode;
                Errors = errors;
            }
        }
        
        private readonly RequestDelegate _next;
        private readonly ILogger<ErrorHandlerMiddleware> _logger;

        public ErrorHandlerMiddleware(RequestDelegate next, ILogger<ErrorHandlerMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task Invoke(HttpContext httpContext)
        {
            if (httpContext == null)
                throw new ArgumentNullException(nameof(httpContext));

            try
            {
                await _next(httpContext);
            }
            catch (HttpStatusCodeException ex)
            {
                LogException(httpContext, (int)ex.StatusCode, ex);

                httpContext.Response.Clear();
                httpContext.Response.Headers.Clear();
                httpContext.Response.StatusCode = (int)ex.StatusCode;

                // ReSharper disable once ConditionIsAlwaysTrueOrFalse
                if (Debugger.IsAttached || IsDebug)
                {
                    await httpContext.Response
                        .WriteAsync(JsonConvert.SerializeObject(ErrorModel.FromException(ex)))
                        .ConfigureAwait(false);
                }
            }
            catch (Exception ex)
            {
                LogException(httpContext, (int)HttpStatusCode.InternalServerError, ex);
                httpContext.Response.Clear();
                httpContext.Response.Headers.Clear();
                httpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            }
        }

        void LogException(HttpContext httpContext, int statusCode, Exception exception)
        {
            try
            {
                _logger.LogCritical(default(EventId), $"HTTP ${httpContext?.Request?.Method} ${httpContext?.Request?.Path} responded {statusCode}. Exception: ${exception}", exception);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Exception logging to logger: " + ex + " for exception: " + exception);
                throw;
            }
        }
    }
}