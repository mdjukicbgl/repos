using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class PriceLadderValue : IBaseEntity
    {
        [Key]
        public int PriceLadderValueId { get; set; }
        public int PriceLadderId { get; set; }
        public int Order { get; set; }
        public decimal Value { get; set; }

        public virtual PriceLadder PriceLadder { get; set; }
    }
}