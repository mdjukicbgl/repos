using Markdown.Data.Entity;
using Markdown.Data.Entity.Ephemeral;

namespace Markdown.Service.Models
{
    public class SmDecay
    {
        private SmDecay()
        {
        }

        public int Stage { get; set; }
        public int StageOffset { get; set; }
        public decimal Decay { get; set; }

        public static SmDecay Build(DecayHierarchy entity)
        {
            if (entity == null)
                return null;

            return new SmDecay
            {
                Stage = entity.Stage,
                StageOffset = entity.StageOffset,
                Decay = entity.Decay
            };
        }
    }
}