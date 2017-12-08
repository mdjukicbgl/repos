using System;
using Markdown.Service.Models;

namespace Markdown.WebApi.Models
{
    public class VmFileUploadAuthorization
    {
        public string Url { get; set; }
        public Guid Guid { get; set; }
        public DateTime ExpirationDate { get; set; }

        public static VmFileUploadAuthorization Build(SmFileUploadAuthorization model)
        {
            return model == null
                ? null
                : new VmFileUploadAuthorization
                {
                    Url = model.Url,
                    Guid = model.Guid,
                    ExpirationDate = model.ExpirationDate
                };
        }
    }
}