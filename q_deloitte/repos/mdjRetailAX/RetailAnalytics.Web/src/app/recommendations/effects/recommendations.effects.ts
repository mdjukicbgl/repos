import { resetFakeAsyncZone } from '@angular/core/testing/src/testing';
import { Injectable } from '@angular/core';
import { Headers } from '@angular/http';
import { AuthHttp } from 'angular2-jwt';
import { Actions, Effect, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../environments/environment';
import * as RecommendationsActions from '../actions/recommendations.actions';


@Injectable()
export class RecommendationsEffects {

  @Effect() $recommendationsLoad = this.actions$
    .ofType(RecommendationsActions.ActionTypes.LOAD_RECOMMENDATIONS)
    .map((x: any) => {
      return {
        scenarioId: (x as any).scenarioId,
        query: (x as any).query
      }
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/scenario/' + payload.scenarioId + '/recommendations' + payload.query)
      .map(res => ({ type: RecommendationsActions.ActionTypes.LOAD_RECOMMENDATIONS_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.LOAD_RECOMMENDATIONS_FAILED }))
    );

  @Effect() $acceptRecommendation = this.actions$
    .ofType(RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION)
    .map((x: any)  => {
      return {
        scenarioId: (x as any).scenarioId,
        recommendationGuid: (x as any).recommendationGuid
      }
    })
    .flatMap(payload => this.http.post(
      environment.endpoint + '/api/scenario/' +
      payload.scenarioId + '/recommendation/' +
      payload.recommendationGuid + '/accept',
      {}, { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
      .map(res => ({ type: RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION_FAILED }))
    );

  @Effect() $rejectRecommendation = this.actions$
    .ofType(RecommendationsActions.ActionTypes.REJECT_RECOMMENDATION)
    .map((x: any)  => {
      return {
        scenarioId: (x as any).scenarioId,
        recommendationGuid: (x as any).recommendationGuid
      }
    })
    .flatMap(
      payload => this.http.post(
        environment.endpoint + '/api/scenario/' +
        payload.scenarioId + '/recommendation/' +
        payload.recommendationGuid + '/reject',
        {}, { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
      .map(res => ({ type: RecommendationsActions.ActionTypes.REJECT_RECOMMENDATION_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.REJECT_RECOMMENDATION_FAILED }))
    );

  @Effect() $acceptAllRecommendations = this.actions$
    .ofType(RecommendationsActions.ActionTypes.ACCEPT_ALL_RECOMMENDATIONS)
    .map((x: any)  => {
      return {
        scenarioId: (x as any).scenarioId,
      }
    })
    .switchMap(payload => this.http.post(
      environment.endpoint + '/api/scenario/' +
      payload.scenarioId + '/recommendation/accept',
      {}, { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
      .map(res => ({ type: RecommendationsActions.ActionTypes.ACCEPT_ALL_RECOMMENDATIONS_COMPLETE }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.ACCEPT_ALL_RECOMMENDATIONS_FAILED }))
    );

  @Effect() $rejectAllRecommendations = this.actions$
    .ofType(RecommendationsActions.ActionTypes.REJECT_ALL_RECOMMENDATIONS)
    .map((x: any) => {
      return {
        scenarioId: (x as any).scenarioId,
      }
    })
    .switchMap(payload => this.http.post(
      environment.endpoint + '/api/scenario/' +
      payload.scenarioId + '/recommendation/reject',
      {}, { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
      .map(res => ({ type: RecommendationsActions.ActionTypes.REJECT_ALL_RECOMMENDATIONS_COMPLETE }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.REJECT_ALL_RECOMMENDATIONS_FAILED }))
    );

  /* Price Ladder */

  @Effect() $priceLadder = this.actions$
    .ofType(RecommendationsActions.ActionTypes.LOAD_PRICE_LADDER)
    .map((x: any)  => {
      return {
        priceLadderId: (x as any).priceLadderId,
      }
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/priceladder/' + payload.priceLadderId )
      .map(res => ({ type: RecommendationsActions.ActionTypes.LOAD_PRICE_LADDER_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.LOAD_PRICE_LADDER_HAS_FAILED }))
    );

  /* Revise */

  @Effect() $reviseRecommendation = this.actions$
    .ofType(RecommendationsActions.ActionTypes.REVISE)
    .map((x: any) => {
      return {
        recommendationGuid: (x as any).recommendationGuid,
        revisions: (x as any).revisions,
      }
    })
    .flatMap(payload => this.http.post(
      environment.endpoint + '/api/recommendation/' +
      payload.recommendationGuid + '/revise',
      { revisions: payload.revisions }, { headers: new Headers({ 'Content-Type': 'application/json' }) })
      .map(res => ({ type: RecommendationsActions.ActionTypes.REVISE_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: RecommendationsActions.ActionTypes.REVISE_HAS_FAILED }))
    );

  constructor(
    private http: AuthHttp,
    private actions$: Actions
  ) { }
}
