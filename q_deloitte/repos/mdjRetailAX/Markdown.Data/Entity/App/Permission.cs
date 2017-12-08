using System;
using System.Collections.Generic;

namespace Markdown.Data.Entity.App
{
    public class Permission: IBaseEntity
    {
		public int PermissionId { get; set; }
		public string PermissionCode { get; set; }
		public string Description { get; set; }

        public ICollection<RolePermission> RolePermission { get; set; }
    }
}
