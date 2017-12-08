namespace Markdown.Common.Extensions
{
    public static class StringParseExtensions
    {
        public static int ParseInt(this string s, int defaultValue)
        {
            int temp;
            return !int.TryParse(s, out temp) ? defaultValue : temp;
        }
    }
}