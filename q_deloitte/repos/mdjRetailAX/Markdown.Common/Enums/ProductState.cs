using System;

namespace Markdown.Common.Enums
{
    [Flags]
    public enum ProductState
    {
        Fatal = 0,
        Ok = 1 << 0,

        InvalidCsp = 1 << 10,
        InvalidElasticityHierarchy = 1 << 11,
        InvalidDecayHierarchy = 1 << 12,
        NoSchedules = 1 << 13
    }
}