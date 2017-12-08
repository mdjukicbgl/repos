import { TestBed, inject } from '@angular/core/testing';
import { ActionReducer, Action } from '@ngrx/store';
import * as DashboardActions from '../actions/dashboard.actions';

import { DashboardState, DashboardReducer, initialState } from './dashboard.reducer'

describe('dashboard reducers', () => {

    var state: DashboardState;

    beforeEach(() => {
        this.state = initialState;
    })

    it('should load dashboard', () => {
        var finalState: DashboardState = initialState;
        finalState.isLoadingDashboard = true;
        finalState.hasLoadingDashboardFailed = false;
        expect(DashboardReducer(this.state, new DashboardActions.LoadDashboardAction())).toEqual(finalState);
    })

    it('should load dashboard failed', () => {
        var action: Action = { type: DashboardActions.ActionTypes.LOAD_DASHBOARD_FAILED };
        var finalState: DashboardState = initialState;
        finalState.isLoadingDashboard = false;
        finalState.hasLoadingDashboardFailed = true;
        expect(DashboardReducer(this.state, action)).toEqual(finalState);
    })

    it('should load scenario', () => {
        var finalState: DashboardState = initialState;
        finalState.isLoadingScenarios = true;
        finalState.hasLoadingScenariosFailed = false;
        expect(DashboardReducer(this.state, new DashboardActions.LoadScenariosAction(''))).toEqual(finalState);
    })

    it('should load scenarios failed', () => {
        var action: Action = { type: DashboardActions.ActionTypes.LOAD_SCENARIOS_FAILED };
        var finalState: DashboardState = initialState;
        finalState.scenarios = [];
        finalState.isLoadingScenarios = false;
        finalState.hasLoadingScenariosFailed = true;
        expect(DashboardReducer(this.state, action)).toEqual(finalState);
    })

})