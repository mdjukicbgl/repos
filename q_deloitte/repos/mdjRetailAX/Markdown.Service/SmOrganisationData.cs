using System;
using System.Collections.Generic;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public class SmOrganisationData
    {
        public int OrganisationId { get; set; }
        public int UserId { get; set; }
        public List<SmPermission> Permissions { get; set; }
        public List<int> ScenarioIds { get; set; }
    }
}
