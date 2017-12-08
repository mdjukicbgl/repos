using System.ComponentModel.DataAnnotations;

namespace Markdown.Data.Entity.App
{
    public class PriceLadderType : IBaseEntity
    {
        [Key]
        public int PriceLadderTypeId { get; set; }
        public string Description { get; set; }
    }
}