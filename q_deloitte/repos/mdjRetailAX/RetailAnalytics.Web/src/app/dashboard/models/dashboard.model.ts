import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';

import { DashboardState, dashboardReducer} from '../reducers/index';
import { StoreMgmtService } from '../../shared/store-mgmt/store-mgmt.service';
import * as dashboardActions from '../actions/dashboard.actions';

import { Scenario } from '../../scenarios/models/scenarios.entity';
import { Dashboard } from './dashboard.entity';

@Injectable()
export class DashboardModel {

    dashboard$: Observable<Dashboard>;
    isLoadingDashboards$: Observable<boolean>;
    hasLoadingDashboardFailed$: Observable<boolean>;
    scenarios$: Observable<Scenario[]>;
    isLoadingScenarios$: Observable<boolean>;
    hasLoadingScenariosFailed$: Observable<boolean>;

    constructor(protected _store: Store<DashboardState>, storeMgmtService: StoreMgmtService) {

        storeMgmtService.addReducers(dashboardReducer);

        this.dashboard$ = this._store.select(s => s.dashboard.dashboard);
        this.isLoadingDashboards$ = this._store.select(s => s.dashboard.isLoadingDashboard);
        this.hasLoadingDashboardFailed$ = this._store.select(s => s.dashboard.hasLoadingDashboardFailed);

        this.scenarios$ = this._store.select(s => s.dashboard.scenarios);
        this.isLoadingScenarios$ = this._store.select(s => s.dashboard.isLoadingScenarios);
        this.hasLoadingScenariosFailed$ = this._store.select(s => s.dashboard.hasLoadingScenariosFailed);

    }

    loadDashboard() {
        this._store.dispatch(new dashboardActions.LoadDashboardAction());
    }

    loadScenarios(query = '') {
        this._store.dispatch(new dashboardActions.LoadScenariosAction(query));
    }

}
