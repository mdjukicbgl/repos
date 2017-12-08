using System;
using Markdown.Common.Enums;

namespace Markdown.WebApi.Models
{
    public class VmFileUploadAuthorize
    {
        public FileUploadType Type { get; set; }
        public string Name { get; set; }
        public long Size { get; set; }
        public DateTime LastModifiedDate { get; set; }
    }
}
