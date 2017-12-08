using System.ComponentModel.DataAnnotations;

namespace Markdown.Common.Filtering
{
    public enum SortDirection
    {
        Asc,
        Desc
    }

    public interface ISort
    {
        string Key { get; set; }
        SortDirection Direction { get; set; }
    }

    public class Sort : ISort
    {
        private Sort()
        {
        }

        public string Key { get; set; }
        public SortDirection Direction { get; set; }

        public static ISort Build(string key, SortDirection direction)
        {
            return new Sort
            {
                Key = key,
                Direction = direction
            };
        }
    }
}