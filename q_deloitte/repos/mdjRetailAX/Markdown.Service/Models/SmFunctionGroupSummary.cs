using System;
using System.Linq;
using System.Collections.Generic;
using Markdown.Common.Enums;
using Markdown.Data.Entity.App;
using FunctionGroupType = Markdown.Common.Enums.FunctionGroupType;
using FunctionType = Markdown.Common.Enums.FunctionType;

namespace Markdown.Service.Models
{
    public class SmFunctionGroupSummary
    {
        public int FunctionGroupId { get; set; }
        public string FunctionVersion { get; set; }
        public FunctionType FunctionType { get; set; }
        public FunctionGroupType FunctionGroupType { get; set; }
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

        private SmFunctionGroupSummary()
        {
            
        }
        
        public static SmFunctionGroupSummary Build(FunctionGroupSummary entity)
        {
            return new SmFunctionGroupSummary
            {
                FunctionGroupId = entity.FunctionGroupId,
                FunctionVersion = entity.FunctionVersion,
                FunctionType = (FunctionType)entity.FunctionTypeId,
                FunctionGroupType = (FunctionGroupType)entity.FunctionGroupTypeId,
                FunctionGroupTypeOrder = entity.FunctionGroupTypeOrder,
                FunctionInstanceTotal = entity.FunctionInstanceTotal,
                LastFunctionInstanceId = entity.LastFunctionInstanceId,
                FunctionInstanceCount = entity.FunctionInstanceCount,
                TimeoutCount = entity.TimeoutCount,
                SuccessCount = entity.SuccessCount,
                ErrorCount = entity.ErrorCount,
                AttemptCountMin = entity.AttemptCountMin,
                AttemptCountAvg = entity.AttemptCountAvg,
                AttemptCountMax = entity.AttemptCountMax,
                Duration = entity.Duration,
                CreatedDate = entity.CreatedDate
            };
        }

        public static List<SmFunctionGroupSummary> Build(List<FunctionGroupSummary> entities)
        {
            return entities?.Select(Build).ToList();
        }
    }
}