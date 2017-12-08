using System;
using System.Collections.Generic;

namespace RetailAnalytics.Data
{
    public interface IOrganisationDataProvider
    {
        int? OrganisationId { get; }
        List<int> ScenarioIds { get; }
		int? UserId { get; }
    }
}
