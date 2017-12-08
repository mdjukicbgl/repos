using System;
using System.Collections.Generic;
using System.Linq;
using Markdown.Data.Entity.App;

namespace Markdown.Service.Models
{
    public class SmPermission
    {
		public int PermissionId { get; set; }
		public string PermissionCode { get; set; }
		public string Description { get; set; }


        public static SmPermission Build(Permission entity)
        {
            if (entity == null)
                return null;

            var smPermission = new SmPermission
            {
                PermissionId = entity.PermissionId,
                PermissionCode = entity.PermissionCode,
                Description = entity.Description
            };

            return smPermission;
        }

		public static List<SmPermission> Build(List<Permission> queryResults)
		{
			var items = queryResults?.Select(Build).ToList();

            return items;
		}
    }
}
