import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { ServerParams } from '../../shared/grid/models/server-params.entity';
import { ServerParamsUtils } from '../../shared/grid/utils/server-params-utils';
import { StoreMgmtService } from '../../shared/store-mgmt/store-mgmt.service';
import * as scenarioActions from '../actions/scenarios.actions';
import { scenariosReducer, ScenariosState } from '../reducers/index';
import {
    Scenario,
} from './scenarios.entity';

@Injectable()
export class ScenariosModel {

    scenariosInitial$: Observable<Scenario[]>;
    scenariosInitialIsLoading$: Observable<boolean>;
    scenariosInitialComplete$: Observable<boolean>;
    scenariosInitialHasFailed$: Observable<boolean>;

    scenarios$: Observable<Scenario[]>;
    scenariosIsLoading$: Observable<boolean>;
    scenariosComplete$: Observable<boolean>;
    scenariosHasFailed$: Observable<boolean>;

    selectedScenario$: Observable<Scenario>;
    selectedScenarioComplete$: Observable<boolean>;
    selectedScenarioIsLoading$: Observable<boolean>;
    selectedScenarioHasFailed$: Observable<boolean>;

    scenariosFilters$: Observable<ServerParams>;

    newScenarioId$: Observable<number>;
    scenarioIsRunning$: Observable<boolean>;
    scenarioRunComplete$:  Observable<boolean>;
    scenarioRunHasFailed$:  Observable<boolean>;

    scenarioIsSaving$: Observable<boolean>;
    scenarioSaveComplete$: Observable<boolean>;
    scenarioSaveHasFailed$: Observable<boolean>;

    constructor(protected _store: Store<ScenariosState>, storeMgmtService: StoreMgmtService) {

        storeMgmtService.addReducers(scenariosReducer);

        /* Scenario Initial */
        this.scenariosInitial$ = this._store.select(s => s.scenarios.scenariosInitial);
        this.scenariosInitialIsLoading$ = this._store.select(s => s.scenarios.scenariosInitialIsLoading);
        this.scenariosInitialComplete$ = this._store.select(s => s.scenarios.scenariosInitialComplete);
        this.scenariosInitialHasFailed$ = this._store.select(s => s.scenarios.scenariosInitialHasFailed);

        /* Scenarios */
        this.scenarios$ = this._store.select(s => s.scenarios.scenarios);
        this.scenariosIsLoading$ = this._store.select(s => s.scenarios.scenariosIsLoading);
        this.scenariosComplete$ = this._store.select(s => s.scenarios.scenariosComplete);
        this.scenariosHasFailed$ = this._store.select(s => s.scenarios.scenariosHasFailed);

        /* Selected Scenario */
        this.selectedScenario$ = this._store.select(s => s.scenarios.selectedScenario);
        this.selectedScenarioComplete$ = this._store.select(s => s.scenarios.selectedScenarioComplete);
        this.selectedScenarioIsLoading$ = this._store.select(s => s.scenarios.selectedScenarioIsLoading);
        this.selectedScenarioHasFailed$ = this._store.select(s => s.scenarios.selectedScenarioHasFailed);

        /* New Scenario Id */
        this.newScenarioId$ = this._store.select(s => s.scenarios.newScenarioId);

        /* Filter */
        this.scenariosFilters$ = this._store.select(s => s.scenarios.scenariosFilter);

        /* Scenario Running */
        this.scenarioIsRunning$ = this._store.select(s => s.scenarios.scenarioIsRunning);
        this.scenarioRunComplete$ = this._store.select(s => s.scenarios.scenarioRunComplete);
        this.scenarioRunHasFailed$ = this._store.select(s => s.scenarios.scenarioRunHasFailed);

        /* Scenario Save */
        this.scenarioIsSaving$ = this._store.select(s => s.scenarios.scenarioIsSaving);
        this.scenarioSaveComplete$ = this._store.select(s => s.scenarios.scenarioSaveComplete);
        this.scenarioSaveHasFailed$ = this._store.select(s => s.scenarios.scenarioSaveHasFailed);

    }

    loadScenariosInitial(query: string = '?pageIndex=1&pageLimit=10000') {//Remove query when server returns more than 50 by default
        this._store.dispatch(new scenarioActions.LoadScenariosInitialAction(query));
    }

    loadScenarios(query: string = '') {
        this._store.dispatch(new scenarioActions.LoadScenariosAction(query));
    }

    loadSelectedScenario(scenarioId: number) {
        this._store.dispatch(new scenarioActions.LoadSelectedScenario(scenarioId));
    }

    loadSelectedScenarioIsLoading(scenarioId: number) {
        this._store.dispatch(new scenarioActions.LoadSelectedScenarioIsLoading(scenarioId));
    }

    loadSelectedScenarioComplete(scenarioId: number) {
        this._store.dispatch(new scenarioActions.LoadSelectedScenarioComplete(scenarioId));
    }

    loadSelectedScenarioHasFailed(scenarioId: number) {
        this._store.dispatch(new scenarioActions.LoadSelectedScenarioHasFailed(scenarioId));
    }

    loadScenariosFiltered(serverParams: ServerParams) {
        this.loadScenarios(ServerParamsUtils.getQuery(serverParams))
    }

    setScenariosFilter(scenariosFilters: ServerParams) {
        this._store.dispatch(new scenarioActions.SetScenariosFilter(scenariosFilters))
    }

    saveScenario(name: string, scheduleMask: string, hierarchyIds: string, fileGuid: string) {
        this._store.dispatch(new scenarioActions.SaveScenario(name, parseInt(scheduleMask, 2), hierarchyIds, fileGuid));
    }

    resetScenarioSaveHasFailed(){
        this._store.dispatch(new scenarioActions.ResetScenarioSaveHasFailed());
    }

    runScenario(scenarioId: number) {
        this._store.dispatch(new scenarioActions.RunScenario(scenarioId));
    }

    resetScenarioRunHasFailed() {
        this._store.dispatch(new scenarioActions.ResetScenarioRunHasFailed());
    }

}
