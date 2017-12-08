using System;
namespace Markdown.WebApi.Models
{
    public abstract class ApiParamsBase
    {
		public string Sort { get; set; }
		private int? _pageIndex { get; set; }
		private int? _pageLimit { get; set; }
        public string MultiSelectKey { get; set; }

		public int PageIndex
		{
			get
			{
				if (!_pageIndex.HasValue)
				{
					return 1;
				}

				return _pageIndex.Value;
			}
			set
			{
				_pageIndex = value;
			}
		}
		public int PageLimit
		{
			get
			{
				if (!_pageLimit.HasValue)
				{
					return 50;
				}

				return _pageLimit.Value;
			}
			set
			{
				_pageLimit = value;
			}
		}

	}
}
