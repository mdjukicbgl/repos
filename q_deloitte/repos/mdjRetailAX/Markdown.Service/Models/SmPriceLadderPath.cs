namespace Markdown.Service.Models
{
    public struct SmPriceLadderPath
    {
        public int PriceLadderId { get; set; }
        public int ScheduleId { get; set; }
        public int MarkdownCount { get; set; }
        public decimal[][] Path { get; set; }
    }
}