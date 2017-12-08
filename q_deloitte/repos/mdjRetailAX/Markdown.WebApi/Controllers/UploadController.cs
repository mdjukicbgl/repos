using System;
using System.Net;
using System.Threading.Tasks;
using Markdown.Common.Enums;
using Microsoft.AspNetCore.Mvc;

using Markdown.Service;
using Markdown.WebApi.Models;
using Microsoft.AspNetCore.Authorization;
using Markdown.WebApi.Auth;

namespace Markdown.WebApi.Controllers
{
    [Route("api/upload")]
	[Authorize(Policy = Policies.MKD_SCENARIO_UPLOAD_FILE)]
    public class UploadController : Controller
    {
        private readonly IFileUploadService _fileUploadService;

        public UploadController(IFileUploadService fileUploadService)
        {
            _fileUploadService = fileUploadService;
        }

        [HttpPost("authorize")]
        public async Task<VmFileUploadAuthorization> Authorize(VmFileUploadAuthorize model)
        {
            if (model.Type == FileUploadType.None)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest, "Type required");
            if (string.IsNullOrWhiteSpace(model.Name))
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest, "Name required");
            if (model.Size <= 0)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest, "Size required");
            if (model.LastModifiedDate == default(DateTime))
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest, "LastModifiedDate required");

            var result = await _fileUploadService.Authorize(model.Type, model.Name, model.Size, model.LastModifiedDate);
            return VmFileUploadAuthorization.Build(result);
        }

        [HttpGet("finish/{guid}")]
        public async Task Finish(Guid guid)
        {
            if (guid == Guid.Empty)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest, "Guid required");
            var result = await _fileUploadService.Finish(guid);
            if (!result)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.NotFound);
        }

        [HttpGet("abort/{guid}")]
        public async Task Abort(Guid guid)
        {
            if (guid == Guid.Empty)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.BadRequest, "Guid required");
            var result = await _fileUploadService.Abort(guid);
            if (!result)
                throw new ErrorHandlerMiddleware.HttpStatusCodeException(HttpStatusCode.NotFound);
        }
    }
}
