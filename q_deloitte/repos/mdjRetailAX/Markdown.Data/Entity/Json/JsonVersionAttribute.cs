using System;
using System.Reflection;

namespace Markdown.Data.Entity.Json
{
    [AttributeUsage(AttributeTargets.Struct | AttributeTargets.Class)]
    public class JsonVersionAttribute : Attribute
    {
        public int Version { get; set; }
        public JsonVersionAttribute(int version = 1)
        {
            Version = version;
        }

        public static int GetVersion(object obj, int defaultVersion = 0)
        {
            var attribute = obj.GetType().GetTypeInfo().GetCustomAttribute<JsonVersionAttribute>();
            return attribute?.Version ?? defaultVersion;
        }
    }
}