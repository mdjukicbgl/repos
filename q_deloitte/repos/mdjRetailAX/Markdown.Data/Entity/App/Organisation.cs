using System;
namespace Markdown.Data.Entity.App
{
    public class Organisation: IBaseEntity
    {
		public int OrganisationId { get; set; }
		public string OrganisationName { get; set; }
    }
}
