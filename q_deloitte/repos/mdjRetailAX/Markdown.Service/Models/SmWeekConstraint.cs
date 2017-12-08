namespace Markdown.Service.Models
{
    public class SmWeekConstraint
    {
        public int Week { get; set; }
        public decimal? Min { get; set; }
        public decimal? Max { get; set; }

        public static SmWeekConstraint Minimum(int week, decimal min)
        {
            return new SmWeekConstraint
            {
                Week = week,
                Min = min
            };
        }

        public static SmWeekConstraint Maximum(int week, decimal max)
        {
            return new SmWeekConstraint
            {
                Week = week,
                Max = max
            };
        }

        public static SmWeekConstraint Fixed(int week, decimal value)
        {
            return new SmWeekConstraint
            {
                Week = week,
                Min = value,
                Max = value,
            };
        }

        public static SmWeekConstraint Range(int week, decimal min, decimal max)
        {
            return new SmWeekConstraint
            {
                Week = week,
                Min = min,
                Max = max,
            };
        }
    }
}