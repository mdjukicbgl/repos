using System;
namespace Markdown.Data.Entity.App
{
    public class RolePermission:IBaseEntity
    {
		public int PermissionId { get; set; }
		public int RoleId { get; set; }
        public Permission Permission { get; set; }
		public Role Role { get; set; }
    }
}
