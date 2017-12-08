using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class PriceLadder : IBaseEntity
    {
        [Key]
        public int PriceLadderId { get; set; }
        public int PriceLadderTypeId { get; set; }
        public string Description { get; set; }

        public virtual PriceLadderType PriceLadderType { get; set; }
        public virtual List<PriceLadderValue> Values { get; set; } = new List<PriceLadderValue>();
    }
}