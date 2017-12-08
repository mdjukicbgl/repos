using System;

namespace Markdown.Service.Models
{
    public class SmFileUploadAuthorization
    {
        public string Url { get; set; }
        public Guid Guid { get; set; }
        public DateTime ExpirationDate { get; set; }
    }
}