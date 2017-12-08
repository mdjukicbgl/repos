import { Action } from '@ngrx/store';
import * as CalendarWeeksActions from '../actions/calendar-weeks.actions';
import {
    CalendarWeeks,
} from '../models/calendar-weeks.entity';

export interface CalendarWeeksState
{

    calendarWeeks: CalendarWeeks;
    calendarWeeksIsLoading: boolean;
    calendarWeeksHasLoadingFailed: boolean;

}

export const initialState: CalendarWeeksState = {

    calendarWeeks: null,
    calendarWeeksIsLoading: false,
    calendarWeeksHasLoadingFailed: false,

}

export function CalendarWeeksReducer(state: CalendarWeeksState = initialState, action: Action): CalendarWeeksState {
    switch (action.type) {

        case CalendarWeeksActions.ActionTypes.LOAD_CALENDAR_WEEKS: {
            return {
                ...state,
                calendarWeeksIsLoading: true,
                calendarWeeksHasLoadingFailed: false,
            };
        }
        case CalendarWeeksActions.ActionTypes.LOAD_CALENDAR_WEEKS_COMPLETE: {
            return {
                ...state,
                calendarWeeks: action.payload,
                calendarWeeksIsLoading: false,
                calendarWeeksHasLoadingFailed: false,
            }
        }
        case CalendarWeeksActions.ActionTypes.LOAD_CALENDAR_WEEKS_FAILED: {
            return {
                ...state,
                calendarWeeks: null,
                calendarWeeksIsLoading: false,
                calendarWeeksHasLoadingFailed: true,
            }
        }

    default:
        return state;
  }
}
