using System;
namespace Markdown.Data.Entity.App
{
    public class UserRole: IBaseEntity
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }
        public User User { get; set; }
		public Role Role { get; set; }
    }
}
