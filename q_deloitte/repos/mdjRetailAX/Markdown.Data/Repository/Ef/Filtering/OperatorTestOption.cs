using System;

namespace Markdown.Data.Repository.Ef.Filtering
{
    [Flags]
    public enum OperatorTestOption
    {
        None,
        ToLower,
        Coalesce
    }
}


