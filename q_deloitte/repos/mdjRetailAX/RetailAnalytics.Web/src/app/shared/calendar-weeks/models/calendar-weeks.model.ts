import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { StoreMgmtService } from '../../store-mgmt/store-mgmt.service';
import * as calendarWeeksActions from '../actions/calendar-weeks.actions';
import { calendarWeeksReducer, CalendarWeeksState } from '../reducers/index';
import {
    CalendarWeeks,
} from './calendar-weeks.entity';

@Injectable()
export class CalendarWeeksModel {

    calendarWeeks$: Observable<CalendarWeeks>;
    calendarWeeksIsLoading$: Observable<boolean>;
    calendarWeeksHasLoadingFailed$: Observable<boolean>;

    constructor(protected _store: Store<CalendarWeeksState>, storeMgmtService: StoreMgmtService) {

        storeMgmtService.addReducers(calendarWeeksReducer);

        this.calendarWeeks$ = this._store.select(s => s.calendarWeeks.calendarWeeks);
        this.calendarWeeksIsLoading$ = this._store.select(s => s.calendarWeeks.calendarWeeksIsLoading);
        this.calendarWeeksHasLoadingFailed$ = this._store.select(s => s.calendarWeeks.calendarWeeksHasLoadingFailed);

    }

    loadCalendarWeeks(startDate: number, numberWeeks: number) {
        this._store.dispatch(new calendarWeeksActions.LoadCalendarWeeks(startDate, numberWeeks));
    }

}
