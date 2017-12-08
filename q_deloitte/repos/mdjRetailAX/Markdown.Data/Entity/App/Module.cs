using System;
namespace Markdown.Data.Entity.App
{
    public class Module: IBaseEntity
    {
		public int ModuleId { get; set; }
		public string Name { get; set; }
        public string Description { get; set; }
    }
}
