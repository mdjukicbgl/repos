using System;
using System.Collections.Generic;

namespace Markdown.Data.Entity.App
{
    public class User: IBaseEntity
    {
		public int UserId { get; set; }
		public string UserName { get; set; }
        public int OrganisationId { get; set; }

        public ICollection<UserRole> UserRoles { get; set; }
    }
}
