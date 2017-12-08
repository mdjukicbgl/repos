using System;
using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class ModelRun : IBaseEntity
    {
        [Key]
        public int ModelId { get; set; }
        public int ModelRunId { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}