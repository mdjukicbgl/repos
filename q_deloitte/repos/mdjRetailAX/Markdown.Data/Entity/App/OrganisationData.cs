using System;
using System.Collections.Generic;

namespace Markdown.Data.Entity.App
{
    public class OrganisationData
    {
		public int OrganisationId { get; set; }
        public int UserId { get; set; }
		public List<Permission> Permissions { get; set; }
		public List<int> ScenarioIds { get; set; }
       
    }
}
