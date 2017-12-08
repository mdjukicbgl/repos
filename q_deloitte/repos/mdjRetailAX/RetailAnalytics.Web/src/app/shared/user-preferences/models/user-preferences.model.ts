import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';

import { UserPreferencesState, userPreferencesReducer } from '../reducers/index';
import { StoreMgmtService } from '../../store-mgmt/store-mgmt.service';
import * as UserPreferencesActions from '../actions/user-preferences.actions';

@Injectable()
export class UserPreferencesModel {

    gridState$: Observable<Array<Object>>;
    sortState$: Observable<Array<Object>>;
    lastScenarioId$: Observable<number>;

    constructor(protected _store: Store<UserPreferencesState>, storeMgmtService: StoreMgmtService) {
        
        storeMgmtService.addReducers(userPreferencesReducer);

        this.gridState$ = this._store.select(s => s.userPreferences.gridStates);
        this.sortState$ = this._store.select(s => s.userPreferences.sortStates);
        this.lastScenarioId$ = this._store.select(s => s.userPreferences.lastScenarioId);
    }

    setGridState(route: string, gridState: Object) {
        this._store.dispatch(new UserPreferencesActions.SetGridState(route, gridState));
    }

    clearGridState(route: string) {
        this._store.dispatch(new UserPreferencesActions.ClearGridState(route));
    }

    setSortState(route: string, sortState: Object) {
        this._store.dispatch(new UserPreferencesActions.SetSortState(route, sortState));
    }

    clearSortState(route: string) {
        this._store.dispatch(new UserPreferencesActions.ClearSortState(route));
    }

    setLastWorkspace(scenarioId: number) {
        this._store.dispatch(new UserPreferencesActions.SetLastWorkSpace(scenarioId));
    }

}