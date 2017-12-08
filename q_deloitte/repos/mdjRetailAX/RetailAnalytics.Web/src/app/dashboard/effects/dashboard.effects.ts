import { Injectable } from '@angular/core';
import { AuthHttp } from 'angular2-jwt';
import { Actions, Effect, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import * as DashboardActions from '../actions/dashboard.actions';

@Injectable()
export class DashboardEffects {

    @Effect() $widgetsLoad = this.actions$
        .ofType(DashboardActions.ActionTypes.LOAD_DASHBOARD)
        .map(toPayload)
        .switchMap(payload => this.http.get(environment.endpoint + '/api/dashboard')
            .map(res => ({ type: DashboardActions.ActionTypes.LOAD_DASHBOARD_COMPLETE, payload: res.json()}))
            .catch(() => Observable.of({ type: DashboardActions.ActionTypes.LOAD_DASHBOARD_FAILED}))
        );

    @Effect() $scenariosLoad = this.actions$
    .ofType(DashboardActions.ActionTypes.LOAD_SCENARIOS)
    .map(toPayload)
    .switchMap(payload => this.http.get(environment.endpoint + '/api/scenario' + payload)
      .map(res => ({ type: DashboardActions.ActionTypes.LOAD_SCENARIOS_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: DashboardActions.ActionTypes.LOAD_SCENARIOS_FAILED }))
    );

    constructor(
        private http: AuthHttp,
        private actions$: Actions
    ) {}

}
