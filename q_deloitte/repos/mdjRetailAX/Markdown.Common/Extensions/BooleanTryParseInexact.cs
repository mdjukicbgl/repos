using System;

namespace Markdown.Common.Extensions
{
    public static class BooleanHelper
    {
        public static bool TryParseInexact(string value, out bool result)
        {
            var v = value.Trim();

            if (v == "0")
            {
                result = false;
                return true;
            }

            if (v == "1")
            {
                result = true;
                return true;
            }

            return Boolean.TryParse(value, out result);
        }
    }
}