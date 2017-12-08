using System.Threading;
using System.Threading.Tasks;

namespace Markdown.Common.Clients
{
    public interface IMarkdownClient
    {
        Task<int> ModelBuild(int modelId, CancellationToken cancellationToken = default(CancellationToken));
        Task<int> ScenarioPrepare(int modelId, int modelRunId, int scenarioId, int organisationId, int userId, int partitionCount, bool calculate = false, bool upload = false, CancellationToken cancellationToken = default(CancellationToken));
        Task ScenarioCalculate(int modelId, int modelRunId, int scenarioId, int organisationId, int userId,int partitionId, int partitionCount, bool upload = false, CancellationToken cancellationToken = default(CancellationToken));
        Task ScenarioUpload(int scenarioId, int organisationId, int userId, int partitionId, int partitionCount, CancellationToken cancellationToken = default(CancellationToken));
    }
}