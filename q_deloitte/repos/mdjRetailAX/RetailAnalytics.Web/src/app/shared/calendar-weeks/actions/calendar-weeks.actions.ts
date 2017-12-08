import { Action } from '@ngrx/store';
import { type } from '../../utils/type';

export const ActionTypes = {

    LOAD_CALENDAR_WEEKS: type('[Markdown] Load Calendar Weeks'),
    LOAD_CALENDAR_WEEKS_COMPLETE: type('[Markdown] Load Calendar Weeks Complete'),
    LOAD_CALENDAR_WEEKS_FAILED: type('[Markdown] Load Calendar Weeks Failed'),

};

export class LoadCalendarWeeks implements Action {
    type = ActionTypes.LOAD_CALENDAR_WEEKS;

    constructor(public startDate: number, public numberWeeks: number) { }
}
