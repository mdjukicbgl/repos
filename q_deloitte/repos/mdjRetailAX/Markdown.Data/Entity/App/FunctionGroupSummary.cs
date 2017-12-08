using System;

namespace Markdown.Data.Entity.App
{
    public class FunctionGroupSummary : IBaseEntity
    {
        public int FunctionGroupId { get; set; }
        public string FunctionVersion { get; set; }
        public int FunctionTypeId { get; set; }
        public string FunctionTypeName { get; set; }
        public int FunctionGroupTypeId { get; set; }
        public string FunctionGroupTypeName { get; set; }
        public int FunctionGroupTypeOrder { get; set; }
        public int FunctionInstanceTotal { get; set; }
        public int? LastFunctionInstanceId { get; set; }
        public int FunctionInstanceCount { get; set; }
        public int TimeoutCount { get; set; }
        public int SuccessCount { get; set; }
        public int ErrorCount { get; set; }
        public int AttemptCountMin { get; set; }
        public double AttemptCountAvg { get; set; }
        public int AttemptCountMax { get; set; }
        public double Duration { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
