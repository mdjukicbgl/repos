using System;
using System.Collections.Generic;
using System.Linq;
using FluentAssertions;
using Markdown.Service.Models;
using Xunit;

namespace Markdown.Service.Tests
{
    public class ScheduleServiceTests
    {
        [Fact]
        public void Get_Schedules_Will_Return_All_Schedules()
        {
            // 10 .. 13 = 4 weeks inclusive
            // 4 weeks as flags = 1 .. 1111

            //  1   0001    
            //  2   0010    
            //  3   0011    
            //  4   0100    
            //  5   0101    
            //  6   0110    
            //  7   0111    
            //  8   1000    
            //  9   1001    
            //  10  1010    
            //  11  1011    
            //  12  1100    
            //  13  1101    
            //  14  1110    
            //  15  1111    

            var options = new SmScheduleOptions
            {
                WeekMin = 10,
                WeekMax = 13,
                WeeksAllowed = 0,
                ExcludeConsecutiveWeeks = false
            };

            var result = new ScheduleService().GetSchedules(options);
            result
                .Select(x => x.ScheduleNumber)
                .ShouldAllBeEquivalentTo(Enumerable.Range(1, 15));
        }

        [Fact]
        public void Get_Schedules_Will_Filter_Consecutive_Schedules()
        {
            //  1   0001    o
            //  2   0010    o
            //  3   0011    
            //  4   0100    o
            //  5   0101    o
            //  6   0110     
            //  7   0111    
            //  8   1000    o
            //  9   1001    o
            //  10  1010    o
            //  11  1011     
            //  12  1100    
            //  13  1101    
            //  14  1110    
            //  15  1111    

            var options = new SmScheduleOptions
            {
                WeekMin = 10,
                WeekMax = 13,
                WeeksAllowed = 0,
                ExcludeConsecutiveWeeks = true
            };

            var expected = new List<int> {1, 2, 4, 5, 8, 9, 10};

            var result = new ScheduleService().GetSchedules(options);
            result
                .Select(x => x.ScheduleNumber)
                .ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Get_Schedules_Will_Return_All_Schedules_With_Allowed_Mask()
        {
            var mask = 255;
            var options = new SmScheduleOptions
            {
                WeekMin = 10,
                WeekMax = 13,
                WeeksAllowed = mask,
                ExcludeConsecutiveWeeks = false
            };

            var expected = Enumerable.Range(1, 15);

            var result = new ScheduleService().GetSchedules(options);
            result
                .Select(x => x.ScheduleNumber)
                .ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Get_Schedules_Will_Allow_Low_Schedules()
        {
            //  1   0001  o  
            //  2   0010  o   
            //  3   0011  o  
            //  4   0100    
            //  5   0101    
            //  6   0110    
            //  7   0111    
            //  8   1000    
            //  9   1001    
            //  10  1010   
            //  11  1011    
            //  12  1100    
            //  13  1101   
            //  14  1110   
            //  15  1111    

            var mask = Convert.ToInt32("11", 2); // 3
            var options = new SmScheduleOptions
            {
                WeekMin = 10,
                WeekMax = 13,
                WeeksAllowed = mask,
                ExcludeConsecutiveWeeks = false
            };

            var expected = new List<int> { 1, 2, 3 };

            var result = new ScheduleService().GetSchedules(options);
            result
                .Select(x => x.ScheduleNumber)
                .ShouldAllBeEquivalentTo(expected);
        }

        [Fact]
        public void Get_Schedules_Will_Allow_High_And_Low_Schedules()
        {
            //  1   0001  o 
            //  2   0010     
            //  3   0011    
            //  4   0100    
            //  5   0101    
            //  6   0110    
            //  7   0111     
            //  8   1000  o  
            //  9   1001  o   
            //  10  1010   
            //  11  1011     
            //  12  1100    
            //  13  1101   
            //  14  1110   
            //  15  1111    

            var mask = Convert.ToInt32("1001", 2); // 9
            var options = new SmScheduleOptions
            {
                WeekMin = 10,
                WeekMax = 13,
                WeeksAllowed = mask,
                ExcludeConsecutiveWeeks = false
            };

            var expected = new List<int> { 1, 8, 9 };

            var result = new ScheduleService().GetSchedules(options);
            result
                .Select(x => x.ScheduleNumber)
                .ShouldAllBeEquivalentTo(expected);
        }


        [Fact]
        public void Get_Schedules_Will_Require_Weeks()
        {
            //  1   0001   
            //  2   0010     
            //  3   0011    
            //  4   0100    
            //  5   0101    
            //  6   0110  o   
            //  7   0111  o   
            //  8   1000    
            //  9   1001     
            //  10  1010   
            //  11  1011     
            //  12  1100    
            //  13  1101   
            //  14  1110  o 
            //  15  1111  o  

            var mask = Convert.ToInt32("0110", 2); // 6
            var options = new SmScheduleOptions
            {
                WeekMin = 10,
                WeekMax = 13,
                WeeksRequired = mask,
                ExcludeConsecutiveWeeks = false
            };

            var expected = new List<int> { 6, 7, 14, 15 };

            var result = new ScheduleService().GetSchedules(options);
            result
                .Select(x => x.ScheduleNumber)
                .ShouldAllBeEquivalentTo(expected);
        }
    }
}