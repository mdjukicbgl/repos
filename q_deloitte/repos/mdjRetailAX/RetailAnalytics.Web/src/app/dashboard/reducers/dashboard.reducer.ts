import { ActionReducer, Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import * as DashboardActions from '../actions/dashboard.actions';

import { Dashboard } from '../models/dashboard.entity';

import { Scenario } from '../../scenarios/models/scenarios.entity';

export interface DashboardState {
    dashboard: Dashboard;
    isLoadingDashboard: boolean;
    hasLoadingDashboardFailed: boolean;
    scenarios: Scenario[];
    isLoadingScenarios: boolean;
    hasLoadingScenariosFailed: boolean;
}

export const initialState: DashboardState = {
    dashboard: null,
    isLoadingDashboard: false,
    hasLoadingDashboardFailed: false,
    scenarios: [],
    isLoadingScenarios: false,
    hasLoadingScenariosFailed: false,
};

export function DashboardReducer(state: DashboardState = initialState, action: Action): DashboardState {


    switch (action.type) {

        case DashboardActions.ActionTypes.LOAD_DASHBOARD: {
            return {
                ...state,
                isLoadingDashboard: true,
                hasLoadingDashboardFailed: false
            };
        }

        case DashboardActions.ActionTypes.LOAD_DASHBOARD_COMPLETE: {
            return {
                ...state,
                dashboard: action.payload.items[0],
                isLoadingDashboard: false,
                hasLoadingDashboardFailed: false
            };
        }

        case DashboardActions.ActionTypes.LOAD_DASHBOARD_FAILED: {
            return {
                ...state,
                isLoadingDashboard: false,
                hasLoadingDashboardFailed: true
            };
        }

        case DashboardActions.ActionTypes.LOAD_SCENARIOS: {
            return {
                ...state,
                isLoadingScenarios: true,
                hasLoadingScenariosFailed: false
            };
        }
        case DashboardActions.ActionTypes.LOAD_SCENARIOS_COMPLETE: {
            return {
                ...state,
                scenarios: action.payload.items,
                isLoadingScenarios: false,
                hasLoadingScenariosFailed: false
            };
        }
        case DashboardActions.ActionTypes.LOAD_SCENARIOS_FAILED: {
            return {
                ...state,
                scenarios: [],
                isLoadingScenarios: false,
                hasLoadingScenariosFailed: true
            };
        }

        default:
            return state;
    }
}
