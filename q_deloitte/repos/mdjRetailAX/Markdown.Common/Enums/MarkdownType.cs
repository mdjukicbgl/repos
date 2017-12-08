using System;

namespace Markdown.Common.Enums
{
    [Flags]
    public enum MarkdownType
    {
        None = 0,
        Existing = 1,
        FullPrice = 2,
        New = 4,
        Further = 8,

        Any = 255
    }
}