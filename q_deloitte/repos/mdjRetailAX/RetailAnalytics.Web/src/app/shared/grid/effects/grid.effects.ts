import { resetFakeAsyncZone } from '@angular/core/testing/src/testing';
import { Injectable } from '@angular/core';
import { Headers } from '@angular/http';
import { AuthHttp } from 'angular2-jwt';
import { Actions, Effect, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../../environments/environment';
import * as GridActions from '../actions/grid.actions';

let dummyData = {
  colId: 'hierarchyName',
  list: [
    "FALL AND WINTER NOVELTY",
    "ACTIVE REPLSHMT BTTMS WMN",
    "Random Item 1",
    "Random Item 2",
    "Random Item 3",
    "Random Item 4",
    "Random Item 5",
    "Random Item 6",
    "Random Item 7",
    "Random Item 8",
    "Random Item 9",
  ]
};

@Injectable()
export class GridEffects {
  constructor(
    private http: AuthHttp,
    private actions$: Actions
  ) {}

  @Effect() $requestUniqueList = this.actions$
    .ofType(GridActions.ActionTypes.REQUEST_UNIQUE_LIST)
    .map((x: any) => {
      return {
        scenarioId: x.scenarioId,
        colId: x.colId
      }
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/scenario/' + payload.scenarioId + '/recommendations/multiselect?multiSelectKey=' + payload.colId)
      .map(res => ({ type: GridActions.ActionTypes.REQUEST_UNIQUE_LIST_COMPLETE, payload: {colId: payload.colId, list: res.json()} }))
      .catch(() => Observable.of({ type: GridActions.ActionTypes.REQUEST_UNIQUE_LIST_FAILED }))
    )
}