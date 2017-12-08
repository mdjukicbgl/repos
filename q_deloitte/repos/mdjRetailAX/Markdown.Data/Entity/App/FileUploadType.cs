using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class FileUploadType : IBaseEntity
    {
        [Key]
        public int FileUploadTypeId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}