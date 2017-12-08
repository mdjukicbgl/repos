using System;
using Newtonsoft.Json;

namespace Markdown.Common.Converters
{
    public class RoundingJsonConverter : JsonConverter
    {
        private readonly int _precision;
        private readonly MidpointRounding _rounding;

        public RoundingJsonConverter() : this(4)
        {
        }

        public RoundingJsonConverter(int precision) : this(precision, MidpointRounding.AwayFromZero)
        {
        }

        public RoundingJsonConverter(int precision, MidpointRounding rounding)
        {
            _precision = precision;
            _rounding = rounding;
        }

        public override bool CanRead => false;

        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(double) || objectType == typeof(double?) || objectType == typeof(decimal) || objectType == typeof(decimal?);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            if (value == null)
            {
                writer.WriteNull();
                return;
            }

            if (value is decimal)
            {
                writer.WriteValue(Math.Round((decimal) value, _precision, _rounding));
                return;
            }

            if (value is double)
            {
                writer.WriteValue(Math.Round((double) value, _precision, _rounding));
                return;
            }

            throw new JsonWriterException("Unknown type: " + value.GetType().Name);
        }
    }
}
