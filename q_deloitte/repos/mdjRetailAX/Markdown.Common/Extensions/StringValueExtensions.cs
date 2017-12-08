using System.Reflection;
using Markdown.Common.Attributes;

namespace Markdown.Common.Extensions
{
    public static class StringValueExtensions
    {
        public static string GetStringValue(this object value)
        {
            var output = value.ToString();
            var type = value.GetType();
            var fi = type.GetField(value.ToString());
            var attrs = fi.GetCustomAttributes(typeof(StringValue), false) as StringValue[];

            if (attrs != null && attrs.Length > 0)
            {
                output = attrs[0].Value;
            }

            return output;
        }
    }
}