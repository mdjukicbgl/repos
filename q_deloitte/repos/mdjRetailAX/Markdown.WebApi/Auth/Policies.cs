using System;
namespace Markdown.WebApi.Auth
{
	public static class Policies
	{
        public const string MKD_DASHBOARD_VIEW = "MKD_DASHBOARD_VIEW";
		public const string MKD_HOME_VIEW = "MKD_HOME_VIEW";
		public const string MKD_SCENARIO_CREATE = "MKD_SCENARIO_CREATE";
        public const string MKD_SCENARIO_CALCULATE = "MKD_SCENARIO_CALCULATE";
        public const string MKD_SCENARIO_PUBLISH = "MKD_SCENARIO_PUBLISH";
        public const string MKD_SCENARIO_PREPARE = "MKD_SCENARIO_PREPARE";
        public const string MKD_SCENARIO_VIEW = "MKD_SCENARIO_VIEW";
        public const string MKD_SCENARIO_UPLOAD = "MKD_SCENARIO_UPLOAD";
        public const string MKD_SCENARIO_UPLOAD_FILE = "MKD_SCENARIO_UPLOAD_FILE";
        public const string MKD_RECOMMENDATION_ACCEPT = "MKD_RECOMMENDATION_ACCEPT";
		public const string MKD_RECOMMENDATION_REJECT = "MKD_RECOMMENDATION_REJECT";
        public const string MKD_RECOMMENDATION_REVISE = "MKD_RECOMMENDATION_REVISE";
        public const string MKD_RECOMMENDATION_VIEW = "MKD_RECOMMENDATION_VIEW";
	}
}
