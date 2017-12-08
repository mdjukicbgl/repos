using System.Data;
using System.Threading.Tasks;
using Dapper;
using Newtonsoft.Json;

using Markdown.Data.Entity.App;
using Markdown.Data.Entity.Json;
using FunctionGroupType = Markdown.Common.Enums.FunctionGroupType;
using FunctionInstanceType = Markdown.Common.Enums.FunctionInstanceType;
using FunctionType = Markdown.Common.Enums.FunctionType;

namespace Markdown.Data.Repository.Ef
{
    public interface IFunctionRepository
    {
        Task<FunctionGroupSummary> Update<T>(int scenarioId, FunctionType functionType, FunctionGroupType functionGroupType,
            string functionVersion,
            int functionInstanceTotal, FunctionInstanceType functionInstanceType, int functionInstanceNumber, T model);
    }

    public class FunctionRepository : IFunctionRepository
    {
        private readonly IMarkdownSqlContext _context;

        public FunctionRepository(IMarkdownSqlContext context)
        {
            _context = context;
        }

        public async Task<FunctionGroupSummary> Update<T>(int scenarioId, FunctionType functionType,
            FunctionGroupType functionGroupType, string functionVersion, int functionInstanceTotal,
            FunctionInstanceType functionInstanceType, int functionInstanceNumber, T model)
        {
            var json = JsonConvert.SerializeObject(model, Formatting.None);
            var jsonVersion = JsonVersionAttribute.GetVersion(model);
         
            var parameters = new DynamicParameters();
            parameters.Add("p_scenario_id", scenarioId, DbType.Int32);
            parameters.Add("p_function_type_name", functionType.ToString(), DbType.String);
            parameters.Add("p_function_group_type_name", functionGroupType.ToString(), DbType.String);
            parameters.Add("p_function_version", functionVersion, DbType.String);
            parameters.Add("p_function_instance_total", functionInstanceTotal, DbType.Int32);
            parameters.Add("p_function_instance_type_name", functionInstanceType.ToString(), DbType.String);
            parameters.Add("p_function_instance_number", functionInstanceNumber, DbType.Int32);
            parameters.Add("p_json", json, DbType.String);
            parameters.Add("p_json_version", jsonVersion, DbType.Int32);

            return await _context.Connection.QuerySingleAsync<FunctionGroupSummary>("fn_function_instance_update", parameters, commandType: CommandType.StoredProcedure);
        }
    }
}