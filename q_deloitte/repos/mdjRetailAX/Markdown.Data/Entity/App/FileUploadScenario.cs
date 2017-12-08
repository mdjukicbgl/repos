using System;
using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class FileUploadScenario : IBaseEntity
    {
	[Key]
	public int FileUploadScenarioId { get; set; }
        public int FileUploadId { get; set; }
        public int ScenarioId { get; set; }
    }
}
