using System;
using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class FileUpload : IBaseEntity
    {
        [Key]
        public int FileUploadId { get; set; }
        public int FileUploadTypeId { get; set; }
        public Guid Guid { get; set; }
        public long Size { get; set; }
        public string Name { get; set; }
        public string PresignedUrl { get; set; }
        public bool IsAborted { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public DateTime ExpirationDate { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? FinishDate { get; set; }
    }
}
