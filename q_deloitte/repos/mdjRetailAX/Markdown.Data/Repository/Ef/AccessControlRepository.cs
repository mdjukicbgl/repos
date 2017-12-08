using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Markdown.Common.Filtering;
using Markdown.Data.Entity.App;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;

namespace Markdown.Data.Repository.Ef
{
    public interface IAccessControlRepository
    {
        OrganisationData GetAll(string emailAddress);
    }

    public class AccessControlRepository : BaseEntityRepository<Permission>, IAccessControlRepository
    {
		public AccessControlRepository(IDbContextFactory<MarkdownEfContext> contextFactory) : base(contextFactory)
        {
		}

        public OrganisationData GetAll(string emailAddress)
        {
            var permissions = (from users in Context.User
                               join userroles in Context.UserRole on users.UserId equals userroles.UserId
                               join rolePermission in Context.RolePermission on userroles.RoleId equals rolePermission.RoleId
                               join permission in Context.Permission on rolePermission.PermissionId equals permission.PermissionId
                               where users.UserName == emailAddress
                               select permission
                              ).ToList();

			var scenarioIds = (from users in Context.User
                               join scenarios in Context.Scenarios on users.OrganisationId equals scenarios.OrganisationId
							   where users.UserName == emailAddress 
                               select scenarios.ScenarioId
							  ).ToList();

            var userData = (from users in Context.User
                            where users.UserName == emailAddress
                            select new { users.OrganisationId, users.UserId }).FirstOrDefault();

            var organisationData = new OrganisationData
            {
                Permissions = permissions,
                ScenarioIds = scenarioIds,
                OrganisationId = userData.OrganisationId,
                UserId = userData.UserId
            };

            return organisationData;
        }
    }
}
