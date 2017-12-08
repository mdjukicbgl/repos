namespace Markdown.Service.Models
{
    public class SmProductPriceLadder : SmPriceLadder
    {
        public static SmProductPriceLadder Build(SmPriceLadder ladder)
        {
            return new SmProductPriceLadder
            {
                PriceLadderId = ladder.PriceLadderId,
                Values = ladder.Values,
                Type = ladder.Type
            };
        }
    }
}