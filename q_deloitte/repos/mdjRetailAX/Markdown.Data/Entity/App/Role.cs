using System;
using System.Collections.Generic;

namespace Markdown.Data.Entity.App
{
    public class Role: IBaseEntity
    {
		public int RoleId { get; set; }
		public string Name { get; set; }
		public string Description { get; set; }
		public string ModuleId { get; set; }

		public ICollection<UserRole> UserRoles { get; set; }
        public ICollection<RolePermission> RolePermission { get; set; }
    }
}
