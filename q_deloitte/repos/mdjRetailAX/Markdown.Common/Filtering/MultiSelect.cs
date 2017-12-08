using System;
namespace Markdown.Common.Filtering
{

    public interface IMultiSelectField
    {
        string Key{ get; set; }
    }

    public class MultiSelectField : IMultiSelectField
    {
      public string Key { get; set; }
    }
}
