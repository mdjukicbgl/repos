using System;
using System.Linq;
using System.Collections.Generic;

using Markdown.Service.Models;

namespace Markdown.Service
{
    public interface IScheduleService
    {
        List<SmDenseSchedule> GetSchedules(SmScheduleOptions options);
    }

    public class ScheduleService : IScheduleService
    {
        /// <summary>
        /// Returns all schedule permutations from 1..n
        /// </summary>
        /// <param name="options"></param>
        /// <returns>A list of dense schedules defining the week</returns>
        public List<SmDenseSchedule> GetSchedules(SmScheduleOptions options)
        {
            return Generate(options.WeekMin, options.WeekCount, options.WeeksAllowed, options.WeeksRequired, options.ExcludeConsecutiveWeeks, options.Constraints);
        }

        private static List<SmDenseSchedule> Generate(int firstWeek, int weekCount, int weeksAllowed, int weeksRequired, bool filterConsecutiveWeeks, List<SmWeekConstraint> constraints)
        {
            if (firstWeek < 0)
                throw new ArgumentException("Cannot be < 0", nameof(firstWeek));

            if (weekCount < 1)
                throw new ArgumentException("Cannot be < 1", nameof(weekCount));

            var range = Enumerable.Range(1, (int)Math.Pow(2, weekCount) - 1);

            // Any of these bits are permissible
            if (weeksAllowed > 0)
                range = range.Where(x => x > 0 && (x & ~weeksAllowed) == 0);

            // Any of these bits are must be set
            if (weeksRequired > 0)
                range = range.Where(x => x > 0 && (x & weeksRequired) == weeksRequired);

            // Filter consecutive weeks
            if (filterConsecutiveWeeks)
                FilterConsecutiveWeeks(ref range, weekCount);

            return range
                .Select(i => SmDenseSchedule.FromInteger(i, firstWeek, weekCount, constraints))
                .OrderBy(x => x.MarkdownCount)
                .ThenBy(x => x.ScheduleNumber)
                .ToList();
        }

        private static void FilterConsecutiveWeeks(ref IEnumerable<int> range, int weekCount)
        {
            range = range.Where(x => !Convert.ToString(x, 2).Contains("11"));
        }
    }
}
