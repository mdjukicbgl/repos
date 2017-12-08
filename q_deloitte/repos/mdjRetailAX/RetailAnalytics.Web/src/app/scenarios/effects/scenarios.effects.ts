import { any } from 'codelyzer/util/function';
import { resetFakeAsyncZone } from '@angular/core/testing/src/testing';
import { Injectable } from '@angular/core';
import { Headers } from '@angular/http';
import { AuthHttp } from 'angular2-jwt';
import { Actions, Effect, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import * as ScenariosActions from '../actions/scenarios.actions';


@Injectable()
export class ScenariosEffects {

  @Effect() $scenariosInitialLoad = this.actions$
    .ofType(ScenariosActions.ActionTypes.LOAD_SCENARIOS_INITIAL)
    .map(toPayload)
    .switchMap(payload => this.http.get(environment.endpoint + '/api/scenario' + payload)
      .map(res => ({ type: ScenariosActions.ActionTypes.LOAD_SCENARIOS_INITIAL_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: ScenariosActions.ActionTypes.LOAD_SCENARIOS_INITIAL_FAILED }))
    );

  @Effect() $scenariosLoad = this.actions$
    .ofType(ScenariosActions.ActionTypes.LOAD_SCENARIOS)
    .map(toPayload)
    .switchMap(payload => this.http.get(environment.endpoint + '/api/scenario' + payload)
      .map(res => ({ type: ScenariosActions.ActionTypes.LOAD_SCENARIOS_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: ScenariosActions.ActionTypes.LOAD_SCENARIOS_FAILED }))
    );

    @Effect() $selectedScenario = this.actions$
    .ofType(ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO)
    .map((x: any)  => {
      return {
        scenarioId: (x as any).scenarioId,
      }
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/scenario/' + payload.scenarioId)
      .map(res => ({ type: ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: ScenariosActions.ActionTypes.LOAD_SELECTED_SCENARIO_FAILED }))
    );

  @Effect() $scenarioSave = this.actions$
    .ofType(ScenariosActions.ActionTypes.SAVE_SCENARIO)
    .map((x: any) => {
      return {
        name: (x as any).name,
        scheduleMask: (x as any).scheduleMask,
        hierarchyIds: (x as any).hierarchyIds,
        fileGuid: (x as any).fileGuid,
      }
    })
    .switchMap(payload => this.http.post(environment.endpoint + '/api/scenario?scenarioName=' + payload.name + '&scheduleMask=' + payload.scheduleMask + payload.hierarchyIds + payload.fileGuid, {}, { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
      .map(res => ({ type: ScenariosActions.ActionTypes.SAVE_SCENARIO_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: ScenariosActions.ActionTypes.SAVE_SCENARIO_FAILED }))
    );

  @Effect() $scenarioRun = this.actions$
    .ofType(ScenariosActions.ActionTypes.RUN_SCENARIO)
    .map(toPayload)
    .switchMap(payload => this.http.post(environment.endpoint + '/api/control/scenario/prepare?modelId=100&modelRunId=100&scenarioId=' + payload + '&partitionCount=10&calculate=true&upload=true', {}, { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
      .map(res => ({ type: ScenariosActions.ActionTypes.RUN_SCENARIO_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: ScenariosActions.ActionTypes.RUN_SCENARIO_FAILED }))
    );

  constructor(
    private http: AuthHttp,
    private actions$: Actions
  ) { }

}
