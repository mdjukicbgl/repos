namespace Markdown.Data.Entity.Ephemeral
{
    public class PriceLadderValue
    {
        public int PriceLadderValueId { get; set; }
        public int PriceLadderId { get; set; }
        public int PriceLadderTypeId { get; set; }
        public int Order { get; set; }
        public decimal Value { get; set; }
    }
}