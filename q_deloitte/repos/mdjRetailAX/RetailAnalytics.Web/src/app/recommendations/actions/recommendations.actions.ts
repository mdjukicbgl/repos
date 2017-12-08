import { Action } from '@ngrx/store';
import { type } from '../../shared/utils/type';
import { Revision } from '../models/recommendations.entity';
import { ServerParams } from "../../shared/grid/models/server-params.entity";

export const ActionTypes = {

    /* Load */
    LOAD_RECOMMENDATIONS: type('[Recommendations] Load Recommendations'),
    LOAD_RECOMMENDATIONS_COMPLETE: type('[Recommendations] Load Recommendations Complete'),
    LOAD_RECOMMENDATIONS_FAILED: type('[Recommendations] Load Recommnedations Failed'),

    /* Filter */
    SET_RECOMMENDATIONS_FILTER: type('[Recommendations] Set Recommendations Filter'),

    /* Accept / Reject */
    ACCEPT_RECOMMENDATION: type('[Recommendations] Accept Recommendation'),
    ACCEPT_RECOMMENDATION_COMPLETE: type('[Recommendations] Accept Recommendation Complete'),
    ACCEPT_RECOMMENDATION_FAILED: type('[Recommendations] Accept Recommendation Failed'),
    REJECT_RECOMMENDATION: type('[Recommendations] Reject Recommendation'),
    REJECT_RECOMMENDATION_COMPLETE: type('[Recommendations] Reject Recommendation Complete'),
    REJECT_RECOMMENDATION_FAILED: type('[Recommendations] Reject Recommendation Failed'),

    /* Accept / Reject All */
    ACCEPT_ALL_RECOMMENDATIONS: type('[Recommendations] Accept All Recommendations'),
    ACCEPT_ALL_RECOMMENDATIONS_COMPLETE: type('[Recommendations] Accept All Recommendations Complete'),
    ACCEPT_ALL_RECOMMENDATIONS_FAILED: type('[Recommendations] Accept All Recommendations Failed'),
    REJECT_ALL_RECOMMENDATIONS: type('[Recommendations] Reject All Recommendations'),
    REJECT_ALL_RECOMMENDATIONS_COMPLETE: type('[Recommendations] Reject All Recommendations Complete'),
    REJECT_ALL_RECOMMENDATIONS_FAILED: type('[Recommendations] Reject All Recommendations Failed'),

    /* Reset Errors */
    RESET_ACCEPT_ALL_RECOMMENDATIONS_HAS_FAILED: type('[Recommendations] Resetting Accept All Recommendations Has Failed'),
    RESET_REJECT_ALL_RECOMMENDATIONS_HAS_FAILED: type('[Recommendations] Resetting Reject All Recommendations Has Failed'),
    RESET_ACCEPT_RECOMMENDATION_HAS_FAILED: type('[Recommendations] Resetting Accept Recommendation Has Failed'),
    RESET_REJECT_RECOMMENDATION_HAS_FAILED: type('[Recommendations] Resetting Reject Recommendation Has Failed'),
    RESET_ACCEPT_ALL_RECOMMENDATIONS_COMPLETE: type('[Recommendations] Resetting Accept All Recommendation Complete'),
    RESET_REJECT_ALL_RECOMMENDATIONS_COMPLETE: type('[Recommendations] Resetting Reject All Recommendation Complete'),
    RESET_REVISE_RECOMMENDATION_HAS_FAILED: type('[Recommendations] Resetting Revise Recommendation Has Failed'),

    /* Price Ladder */
    LOAD_PRICE_LADDER: type('[Recommendations] Load Price Ladder'),
    LOAD_PRICE_LADDER_COMPLETE: type('[Recommendations] Load Price Ladder Complete'),
    LOAD_PRICE_LADDER_HAS_FAILED: type('[Recommendations] Load Price Ladder Has Failed'),

    /* Revise */
    REVISE: type('[Recommendations] Revise Recommendation'),
    REVISE_COMPLETE: type('[Recommendations] Revise Recommendation Complete'),
    REVISE_HAS_FAILED: type('[Recommendations] Revise Recommendation Has Failed'),
};

export class LoadRecommendationsAction implements Action {
    type = ActionTypes.LOAD_RECOMMENDATIONS;

    constructor(public scenarioId: number, public query: string ) { }
}

export class SetRecommendationsFilter implements Action {
    type = ActionTypes.SET_RECOMMENDATIONS_FILTER;

    constructor(public payload: ServerParams) {}
}

export class AcceptRecommendation implements Action {
    type = ActionTypes.ACCEPT_RECOMMENDATION;

    constructor(public scenarioId: number, public recommendationGuid: string) {}
}

export class RejectRecommendation implements Action {
    type = ActionTypes.REJECT_RECOMMENDATION;

    constructor(public scenarioId: number, public recommendationGuid: string) {}
}

export class AcceptAllRecommendations implements Action {
    type = ActionTypes.ACCEPT_ALL_RECOMMENDATIONS;

    constructor(public scenarioId: number) {}
}

export class RejectAllRecommendations implements Action {
    type = ActionTypes.REJECT_ALL_RECOMMENDATIONS;

    constructor(public scenarioId: number) {}
}

/* Reset Error States */

export class ResetAcceptAllRecommendationsHasFailed implements Action {
    type = ActionTypes.RESET_ACCEPT_ALL_RECOMMENDATIONS_HAS_FAILED;

    constructor() {}
}

export class ResetRejectAllRecommendationsHasFailed implements Action {
    type = ActionTypes.RESET_REJECT_ALL_RECOMMENDATIONS_HAS_FAILED;

    constructor() {}
}

export class ResetAcceptRecommendationHasFailed implements Action {
    type = ActionTypes.RESET_ACCEPT_RECOMMENDATION_HAS_FAILED;

    constructor() {}
}

export class ResetRejectRecommendationHasFailed implements Action {
    type = ActionTypes.RESET_REJECT_RECOMMENDATION_HAS_FAILED;

    constructor() {}
}

export class ResetAcceptAllRecommendationsComplete implements Action {
    type = ActionTypes.RESET_ACCEPT_ALL_RECOMMENDATIONS_COMPLETE;

    constructor() {}
}

export class ResetRejectAllRecommendationsComplete implements Action {
    type = ActionTypes.RESET_REJECT_ALL_RECOMMENDATIONS_COMPLETE;

    constructor() {}
}

export class ResetReviseRecommendationHasFailed implements Action {
    type = ActionTypes.RESET_REVISE_RECOMMENDATION_HAS_FAILED;

    constructor() {}
}

/* Price Ladder */

export class LoadPriceLadder implements Action {
    type = ActionTypes.LOAD_PRICE_LADDER;

    constructor(public priceLadderId: number) {}
}

/* Revise */

export class Revise implements Action {
    type = ActionTypes.REVISE;

    constructor(public recommendationGuid: string, public revisions: Revision[]) {}
}
