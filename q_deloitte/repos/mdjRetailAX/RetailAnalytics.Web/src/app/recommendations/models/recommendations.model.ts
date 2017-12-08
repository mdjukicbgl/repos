import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { ServerParams } from '../../shared/grid/models/server-params.entity';
import { ServerParamsUtils } from '../../shared/grid/utils/server-params-utils';
import { StoreMgmtService } from '../../shared/store-mgmt/store-mgmt.service';
import * as recommendationsActions from '../actions/recommendations.actions';
import { recommendationsReducer, RecommendationsState } from '../reducers/index';
import { GridRecommendations, PriceLadder, Revision, ScenarioProductRecommendation } from './recommendations.entity';

@Injectable()
export class RecommendationsModel {

    recommendations$: Observable<GridRecommendations>;
    recommendationsIsLoading$: Observable<boolean>;
    recommendationsComplete$: Observable<boolean>;
    recommendationsHasFailed$: Observable<boolean>;

    recommendationsFilters$: Observable<ServerParams>;

    acceptRecommendationIsLoading$: Observable<boolean>;
    acceptRecommendationHasFailed$: Observable<boolean>;
    rejectRecommendationIsLoading$: Observable<boolean>;
    rejectRecommendationHasFailed$: Observable<boolean>;
    updatedRecommendations$: Observable<ScenarioProductRecommendation[]>;

    acceptAllRecommendationsComplete$: Observable<boolean>;
    acceptAllRecommendationsIsLoading$: Observable<boolean>;
    acceptAllRecommendationsHasFailed$: Observable<boolean>;
    rejectAllRecommendationsComplete$: Observable<boolean>;
    rejectAllRecommendationsIsLoading$: Observable<boolean>;
    rejectAllRecommendationsHasFailed$: Observable<boolean>;

    priceLadder$: Observable<PriceLadder>;
    priceLadderComplete$: Observable<boolean>;
    priceLadderIsLoading$: Observable<boolean>;
    priceLadderHasFailed$: Observable<boolean>;

    reviseComplete$: Observable<boolean>;
    reviseIsLoading$: Observable<boolean>;
    reviseHasFailed$: Observable<boolean>;

    constructor(protected _store: Store<RecommendationsState>, storeMgmtService: StoreMgmtService) {

        storeMgmtService.addReducers(recommendationsReducer);

        this.updatedRecommendations$ = this._store.select(s => s.recommendations.updatedRecommendations);

        /* Recommendations */
        this.recommendations$ = this._store.select(s => s.recommendations.recommendations);
        this.recommendationsIsLoading$ = this._store.select(s => s.recommendations.recommendationsIsLoading);
        this.recommendationsComplete$ = this._store.select(s => s.recommendations.recommendationsComplete);
        this.recommendationsHasFailed$ = this._store.select(s => s.recommendations.recommendationsHasFailed);

        /* Filters */
        this.recommendationsFilters$ = this._store.select(s => s.recommendations.recommendationsFilter);

        /* Accept Reject */
        this.acceptRecommendationIsLoading$ = this._store.select(s => s.recommendations.acceptRecommendationIsLoading);
        this.acceptRecommendationHasFailed$ = this._store.select(s => s.recommendations.acceptRecommendationHasFailed);
        this.rejectRecommendationIsLoading$ = this._store.select(s => s.recommendations.rejectRecommendationIsLoading);
        this.rejectRecommendationHasFailed$ = this._store.select(s => s.recommendations.rejectRecommendationHasFailed);

        /* Accept/Reject All */
        this.acceptAllRecommendationsComplete$ = this._store.select(s => s.recommendations.acceptAllRecommendationsComplete);
        this.acceptAllRecommendationsIsLoading$ = this._store.select(s => s.recommendations.acceptAllRecommendationsIsLoading);
        this.acceptAllRecommendationsHasFailed$ = this._store.select(s => s.recommendations.acceptAllRecommendationsHasFailed);
        this.rejectAllRecommendationsComplete$ = this._store.select(s => s.recommendations.rejectAllRecommendationsComplete);
        this.rejectAllRecommendationsIsLoading$ = this._store.select(s => s.recommendations.rejectAllRecommendationsIsLoading);
        this.rejectAllRecommendationsHasFailed$ = this._store.select(s => s.recommendations.rejectAllRecommendationsHasFailed);

        /* Price Ladder */
        this.priceLadder$ = this._store.select(s => s.recommendations.priceLadder);
        this.priceLadderComplete$ = this._store.select(s => s.recommendations.priceLadderComplete);
        this.priceLadderIsLoading$ = this._store.select(s => s.recommendations.priceLadderIsLoading);
        this.priceLadderHasFailed$ = this._store.select(s => s.recommendations.priceLadderHasFailed);

        /* Revise */
        this.reviseComplete$ = this._store.select(s => s.recommendations.reviseComplete);
        this.reviseIsLoading$ = this._store.select(s => s.recommendations.reviseIsLoading);
        this.reviseHasFailed$ = this._store.select(s => s.recommendations.reviseHasFailed);

    }

    loadRecommendations(scenarioId: number, query = '') {
        this._store.dispatch(new recommendationsActions.LoadRecommendationsAction(scenarioId, query))
    }

    loadRecommendationsFiltered(scenarioId: number, serverParams: ServerParams){
      this.loadRecommendations(scenarioId, ServerParamsUtils.getQuery(serverParams))
    }

    acceptRecommendation(scenarioId: number, recommendationGuid: string) {
        this._store.dispatch(new recommendationsActions.AcceptRecommendation(scenarioId,recommendationGuid))
    }

    rejectRecommendation(scenarioId: number, recommendationGuid: string) {
        this._store.dispatch(new recommendationsActions.RejectRecommendation(scenarioId,recommendationGuid))
    }

    setRecommendationsFilter(recommendationsFilters: ServerParams) {
        this._store.dispatch(new recommendationsActions.SetRecommendationsFilter(recommendationsFilters))
    }

    acceptAllRecommendations(scenarioId: number) {
        this._store.dispatch(new recommendationsActions.AcceptAllRecommendations(scenarioId))
    }

    rejectAllRecommendations(scenarioId: number) {
        this._store.dispatch(new recommendationsActions.RejectAllRecommendations(scenarioId))
    }

    /* Reset Error States */

    resetAcceptAllRecommendationsHasFailed() {
      this._store.dispatch(new recommendationsActions.ResetAcceptAllRecommendationsHasFailed())
    }

    resetRejectAllRecommendationsHasFailed() {
      this._store.dispatch(new recommendationsActions.ResetRejectAllRecommendationsHasFailed())
    }

    resetAcceptRecommendationHasFailed() {
      this._store.dispatch(new recommendationsActions.ResetAcceptRecommendationHasFailed())
    }

    resetRejectRecommendationHasFailed() {
      this._store.dispatch(new recommendationsActions.ResetRejectRecommendationHasFailed())
    }

    resetAcceptAllRecommendationsComplete() {
      this._store.dispatch(new recommendationsActions.ResetAcceptAllRecommendationsComplete())
    }

    resetRejectAllRecommendationsComplete() {
      this._store.dispatch(new recommendationsActions.ResetRejectAllRecommendationsComplete())
    }

    resetReviseRecommendationHasFailed() {
      this._store.dispatch(new recommendationsActions.ResetReviseRecommendationHasFailed())
    }

    /* Price Ladder */

    loadPriceLadder(priceLadderId: number) {
      this._store.dispatch(new recommendationsActions.LoadPriceLadder(priceLadderId));
    }

    revise(recommendationGuid: string, revisions: Revision[]) {
      this._store.dispatch(new recommendationsActions.Revise(recommendationGuid, revisions));
    }
}
