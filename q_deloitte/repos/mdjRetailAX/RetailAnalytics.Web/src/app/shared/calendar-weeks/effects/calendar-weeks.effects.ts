import { resetFakeAsyncZone } from '@angular/core/testing/src/testing';
import { Injectable } from '@angular/core';
import { Headers } from '@angular/http';
import { AuthHttp } from 'angular2-jwt';
import { Actions, Effect, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../../environments/environment';
import * as CalendarWeeksActions from '../actions/calendar-weeks.actions';


@Injectable()
export class CalendarWeeksEffects {

  @Effect() $calendarWeeksLoad = this.actions$
    .ofType(CalendarWeeksActions.ActionTypes.LOAD_CALENDAR_WEEKS)
    .map((x: any) => {
      return {
        startDate: (x as any).startDate,
        numberWeeks: (x as any).numberWeeks
      }
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/calendar/' + payload.startDate + '/' + payload.numberWeeks)
      .map(res => ({ type: CalendarWeeksActions.ActionTypes.LOAD_CALENDAR_WEEKS_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: CalendarWeeksActions.ActionTypes.LOAD_CALENDAR_WEEKS_FAILED }))
    );

  constructor(
    private http: AuthHttp,
    private actions$: Actions
  ) { }


}
