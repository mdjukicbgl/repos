using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Markdown.Common.Filtering;
using Markdown.Data.Repository.Ef;
using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IAccessControlService
    {
        SmOrganisationData GetAll(string emailAddress);
    }

    public class AccessControlService:IAccessControlService
    {
        private readonly IAccessControlRepository _accessControlRepository;
        
        public AccessControlService(IAccessControlRepository accessControlRepository)
        {
            _accessControlRepository = accessControlRepository;
        }

        public SmOrganisationData GetAll(string emailAddress)
        {
           var results=  _accessControlRepository.GetAll(emailAddress);

            var smOrganisationData = new SmOrganisationData
            {
                OrganisationId = results.OrganisationId,
                UserId = results.UserId,
                ScenarioIds = results.ScenarioIds,
                Permissions = SmPermission.Build(results.Permissions)
            };

            return smOrganisationData;
        }
    }
}
