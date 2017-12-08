import '@ngrx/core/add/operator/select';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { AppState } from '../../../app/app.reducer';
import { ServerParams } from '../../shared/grid/models/server-params.entity';
import * as RecommendationsActions from '../actions/recommendations.actions';
import { GridRecommendations, PriceLadder, ScenarioProductRecommendation } from '../models/recommendations.entity';

import { Scenario } from '../../scenarios/models/scenarios.entity';

export interface RecommendationsState
{

    recommendations: GridRecommendations;
    recommendationsIsLoading: boolean;
    recommendationsComplete: boolean;
    recommendationsHasFailed: boolean;

    recommendationsFilter: ServerParams;

    acceptRecommendationIsLoading: boolean;
    acceptRecommendationHasFailed: boolean;
    rejectRecommendationIsLoading: boolean;
    rejectRecommendationHasFailed: boolean;
    updatedRecommendations: ScenarioProductRecommendation[];

    acceptAllRecommendationsComplete: boolean;
    acceptAllRecommendationsIsLoading: boolean;
    acceptAllRecommendationsHasFailed: boolean;
    rejectAllRecommendationsComplete: boolean;
    rejectAllRecommendationsIsLoading: boolean;
    rejectAllRecommendationsHasFailed: boolean;

    scenario: Scenario;

    priceLadder: PriceLadder;
    priceLadderComplete: boolean;
    priceLadderIsLoading: boolean;
    priceLadderHasFailed: boolean;

    reviseComplete: boolean;
    reviseHasFailed: boolean;
    reviseIsLoading: boolean;
}

export const initialState: RecommendationsState = {

    recommendations: null,
    recommendationsIsLoading: false,
    recommendationsComplete: false,
    recommendationsHasFailed: false,

    recommendationsFilter: { sorts: [], filters: [], paging: { pageIndex:1, pageLimit:100 }},

    acceptRecommendationIsLoading: false,
    acceptRecommendationHasFailed: false,
    rejectRecommendationIsLoading: false,
    rejectRecommendationHasFailed: false,
    updatedRecommendations: null,

    acceptAllRecommendationsComplete: false,
    acceptAllRecommendationsIsLoading: false,
    acceptAllRecommendationsHasFailed: false,
    rejectAllRecommendationsComplete: false,
    rejectAllRecommendationsIsLoading: false,

    rejectAllRecommendationsHasFailed: false,

    scenario: null,

    priceLadder: null,
    priceLadderComplete: false,
    priceLadderIsLoading: false,
    priceLadderHasFailed: false,

    reviseComplete: false,
    reviseHasFailed: false,
    reviseIsLoading: false,
}

export function RecommendationsReducer(state: RecommendationsState = initialState, action: Action): RecommendationsState {
    switch (action.type) {

        /* Recommendations */
        case RecommendationsActions.ActionTypes.LOAD_RECOMMENDATIONS: {
            return {
                ...state,
                recommendationsIsLoading: true,
                recommendationsComplete: false,
                recommendationsHasFailed: false
            }
        }
        case RecommendationsActions.ActionTypes.LOAD_RECOMMENDATIONS_COMPLETE: {
            return {
                ...state,
                recommendations: flattenRecommendationsViewForGrid(action.payload.items),
                recommendationsIsLoading: false,
                recommendationsComplete: true,
                recommendationsHasFailed: false
            }
        }
        case RecommendationsActions.ActionTypes.LOAD_RECOMMENDATIONS_FAILED: {
            return {
                ...state,
                recommendationsIsLoading: false,
                recommendationsComplete: false,
                recommendationsHasFailed: true
            }
        }

        /* Filter */
        case RecommendationsActions.ActionTypes.SET_RECOMMENDATIONS_FILTER: {
            return {
                ...state,
                recommendationsFilter: (<ServerParams>action.payload)
            }
        }

        /* Accept/Reject Recommendations */
        // TODO: this should not return all, only the singular changed

        case RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION: {
            return {
                ...state,
                acceptRecommendationIsLoading: true,
                acceptRecommendationHasFailed: false
            }
        }
        case RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION_COMPLETE: {
            return {
                ...state,
                recommendations: flattenRecommendationsViewForGrid(updateScenarioRecommendations(state.recommendations,action.payload)),
                updatedRecommendations: [flattenRecommendationForGrid(action.payload)],
                acceptRecommendationIsLoading: false,
                acceptRecommendationHasFailed: false
            }
        }
        case RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION_FAILED: {
            return {
                ...state,
                acceptRecommendationIsLoading: false,
                acceptRecommendationHasFailed: true
            }
        }

        case RecommendationsActions.ActionTypes.REJECT_RECOMMENDATION: {
            return {
                ...state,
                rejectRecommendationIsLoading: true,
                rejectRecommendationHasFailed: false
            }
        }
        case RecommendationsActions.ActionTypes.REJECT_RECOMMENDATION_COMPLETE: {
            return {
                ...state,
                recommendations: flattenRecommendationsViewForGrid(updateScenarioRecommendations(state.recommendations,action.payload)),
                updatedRecommendations: [flattenRecommendationForGrid(action.payload)],
                rejectRecommendationIsLoading: false,
                rejectRecommendationHasFailed: false
            }
        }
        case RecommendationsActions.ActionTypes.ACCEPT_RECOMMENDATION_FAILED: {
            return {
                ...state,
                rejectRecommendationIsLoading: false,
                rejectRecommendationHasFailed: true
            }
        }

        /* Accept/Reject All Recommendations */

        case RecommendationsActions.ActionTypes.ACCEPT_ALL_RECOMMENDATIONS: {
            return {
                ...state,
                acceptAllRecommendationsComplete: false,
                acceptAllRecommendationsIsLoading: true,
                acceptAllRecommendationsHasFailed: false
            }
        }

        case RecommendationsActions.ActionTypes.ACCEPT_ALL_RECOMMENDATIONS_COMPLETE: {
            return {
                ...state,
                acceptAllRecommendationsComplete: true,
                acceptAllRecommendationsIsLoading: false,
                acceptAllRecommendationsHasFailed: false
            }
        }

        case RecommendationsActions.ActionTypes.ACCEPT_ALL_RECOMMENDATIONS_FAILED: {
            return {
                ...state,
                acceptAllRecommendationsComplete: false,
                acceptAllRecommendationsIsLoading: false,
                acceptAllRecommendationsHasFailed: true
            }
        }

        case RecommendationsActions.ActionTypes.REJECT_ALL_RECOMMENDATIONS: {
            return {
                ...state,
                rejectAllRecommendationsComplete: false,
                rejectAllRecommendationsIsLoading: true,
                rejectAllRecommendationsHasFailed: false
            }
        }

        case RecommendationsActions.ActionTypes.REJECT_ALL_RECOMMENDATIONS_COMPLETE: {
            return {
                ...state,
                rejectAllRecommendationsComplete: true,
                rejectAllRecommendationsIsLoading: false,
                rejectAllRecommendationsHasFailed: false
            }
        }

        case RecommendationsActions.ActionTypes.REJECT_ALL_RECOMMENDATIONS_FAILED: {
            return {
                ...state,
                rejectAllRecommendationsComplete: false,
                rejectAllRecommendationsIsLoading: false,
                rejectAllRecommendationsHasFailed: true
            }
        }

        /* Reset Recommendations Errors */

        case RecommendationsActions.ActionTypes.RESET_ACCEPT_ALL_RECOMMENDATIONS_HAS_FAILED: {
            return {
                ...state,
                acceptAllRecommendationsHasFailed: false,
            }
        }

        case RecommendationsActions.ActionTypes.RESET_REJECT_ALL_RECOMMENDATIONS_HAS_FAILED: {
            return {
                ...state,
                rejectAllRecommendationsHasFailed: false
            }
        }

        case RecommendationsActions.ActionTypes.RESET_ACCEPT_RECOMMENDATION_HAS_FAILED: {
            return {
                ...state,
                acceptRecommendationHasFailed: false,
            }
        }

        case RecommendationsActions.ActionTypes.RESET_REJECT_RECOMMENDATION_HAS_FAILED: {
            return {
                ...state,
                rejectRecommendationHasFailed: false,
            }
        }

        case RecommendationsActions.ActionTypes.RESET_ACCEPT_ALL_RECOMMENDATIONS_COMPLETE: {
            return {
                ...state,
                acceptAllRecommendationsComplete: false,
            }
        }

        case RecommendationsActions.ActionTypes.RESET_REJECT_ALL_RECOMMENDATIONS_COMPLETE: {
            return {
                ...state,
                rejectAllRecommendationsComplete: false,
            }
        }

        /* Price Ladder */

        case RecommendationsActions.ActionTypes.LOAD_PRICE_LADDER: {
            return {
                ...state,
                priceLadderComplete: false,
                priceLadderHasFailed: false,
                priceLadderIsLoading: true
            }
        }

        case RecommendationsActions.ActionTypes.LOAD_PRICE_LADDER_COMPLETE: {
            return {
                ...state,
                priceLadder: action.payload,
                priceLadderComplete: true,
                priceLadderHasFailed: false,
                priceLadderIsLoading: false
            }
        }

        case RecommendationsActions.ActionTypes.LOAD_PRICE_LADDER_HAS_FAILED: {
            return {
                ...state,
                priceLadderComplete: false,
                priceLadderHasFailed: true,
                priceLadderIsLoading: false
            }
        }

        /* Revise */

        case RecommendationsActions.ActionTypes.REVISE: {
            return {
                ...state,
                reviseComplete: false,
                reviseHasFailed: false,
                reviseIsLoading: true
            }
        }

        case RecommendationsActions.ActionTypes.REVISE_COMPLETE: {
            return {
                ...state,
                recommendations: flattenRecommendationsViewForGrid(updateScenarioRecommendations(state.recommendations,action.payload)),
                updatedRecommendations: [flattenRecommendationForGrid(action.payload)],
                reviseComplete: true,
                reviseHasFailed: false,
                reviseIsLoading: false
            }
        }

        case RecommendationsActions.ActionTypes.REVISE_HAS_FAILED: {
            return {
                ...state,
                reviseComplete: false,
                reviseHasFailed: true,
                reviseIsLoading: false
            }
        }

        case RecommendationsActions.ActionTypes.RESET_REVISE_RECOMMENDATION_HAS_FAILED: {
            return {
                ...state,
                reviseHasFailed: false,
            }
        }

    default:
        return state;
  }
}

export function updateScenarioRecommendations(recommendations, updatedRecommendation) {
  let newRecommendationsObject = recommendations.items.map(x => Object.assign({}, x));
  let objIndex = newRecommendationsObject.
                  findIndex((recommendation =>
                  recommendation.recommendationGuid === updatedRecommendation.recommendationGuid));
  newRecommendationsObject[objIndex] = updatedRecommendation;
  return newRecommendationsObject;
}

export function flattenRecommendationsViewForGrid(recommendations) {
  let projectionCount;
  let scheduleMask;
  let priceLadderId;
  if (recommendations && recommendations.length > 0) {
    recommendations.forEach((recommendation ) => {
      // Flatten Recommendation
      recommendation = flattenRecommendationForGrid(recommendation);
      // Update projection
      if (recommendation.projections && recommendation.projections.length > 0 && !projectionCount) {
        projectionCount = recommendation.projections.length;
      }
      // Schedule Mask
      if (recommendation.scheduleMask && !scheduleMask && projectionCount) {
        scheduleMask = padDigits(recommendation.scheduleMask.toString(2), projectionCount).split('').reverse();
      }
      // Price Ladder Id
      if (recommendation.priceLadderId && !priceLadderId) {
        priceLadderId = recommendation.priceLadderId;
      }
    })
  }

  return { items: recommendations, projectionCount: projectionCount, scheduleMask: scheduleMask, priceLadderId: priceLadderId};
}

export function flattenRecommendationForGrid(recommendation) {
  if(recommendation.projections) {
    recommendation.projections.forEach((projection, index) => {
        recommendation['price' + (index + 1)] =  projection.price
        recommendation['discount' + (index + 1)] = !projection.isMarkdown && projection.discount === 0 ? recommendation.currentMarkdownDepth : projection.discount
        recommendation['week' + (index + 1)] = projection.week
        recommendation['isMarkdown' + (index + 1)] = projection.isMarkdown
        recommendation['isCsp' + (index + 1)] = projection.isCsp
        recommendation['isPadding' + (index + 1)] = projection.isPadding
    })
  }
  return recommendation;
}

export function padDigits(number, digits) {
    return Array(Math.max(digits - String(number).length + 1, 0)).join('0') + number;
}
