using System;

namespace Markdown.Common.Attributes
{
    public class StringValue : Attribute
    {
        public StringValue(string value)
        {
            Value = value;
        }

        public string Value { get; }
    }
}