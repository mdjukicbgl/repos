import { DashboardState, DashboardReducer} from './dashboard.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../app/app.reducer';

export interface DashboardState extends AppState {
    dashboard: DashboardState;
}

export const dashboardReducer = { dashboard: DashboardReducer };
