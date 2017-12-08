using System;
using System.Collections.Generic;
using RetailAnalytics.Data;

namespace Markdown.Function.Common
{
    public class OrganisationDataProvider : IOrganisationDataProvider
    {
        public int? OrganisationId 
        {
            get { return null; }
        }

		public List<int> ScenarioIds
		{
			get
			{
				return new List<int>();
			}
		}

        public int? UserId
		{
			get { return null; }
		}
    }
}
