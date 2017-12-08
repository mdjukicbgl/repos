export interface Week {
  weekNumber: number;
  weekStart: number;
  dayWeekStart: number;
  friendlyDate: string;
  selected: boolean;
}

export interface CalendarWeeks {
  calendarId: number;
  calendarName: string;
  startDate: number;
  numberWeeks: number;
  weeks: Week[];
}
