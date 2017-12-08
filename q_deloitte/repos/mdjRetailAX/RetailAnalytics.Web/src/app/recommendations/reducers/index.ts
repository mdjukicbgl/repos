import { RecommendationsState, RecommendationsReducer} from './recommendations.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../app/app.reducer';

export interface RecommendationsState extends AppState {
    recommendations: RecommendationsState
}

export const recommendationsReducer = { recommendations: RecommendationsReducer };
