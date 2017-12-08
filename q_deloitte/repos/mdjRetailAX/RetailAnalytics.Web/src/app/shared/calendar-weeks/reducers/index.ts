import { CalendarWeeksState, CalendarWeeksReducer} from './calendar-weeks.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../../app/app.reducer';

export interface CalendarWeeksState extends AppState {
    calendarWeeks: CalendarWeeksState
}

export const calendarWeeksReducer = { calendarWeeks: CalendarWeeksReducer };
