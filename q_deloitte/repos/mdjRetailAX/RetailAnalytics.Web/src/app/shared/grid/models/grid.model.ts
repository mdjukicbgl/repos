import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';

import { GridState, gridReducer } from '../reducers/index';
import { StoreMgmtService } from '../../store-mgmt/store-mgmt.service';
import { UniqueList } from './unique-list.entity';
import * as GridActions from '../actions/grid.actions';

@Injectable()
export class GridModel {

    uniqueLists$:Observable<Array<UniqueList>>;
    uniqueListsIsLoading$: Observable<boolean>;
    uniqueListsComplete$: Observable<boolean>;
    uniqueListsHasFailed$: Observable<boolean>;
    
    constructor(protected _store: Store<GridState>, storeMgmtService: StoreMgmtService) {
        storeMgmtService.addReducers(gridReducer);

        this.uniqueLists$ = _store.select(s => s.grid.uniqueLists);
        this.uniqueListsIsLoading$ = _store.select(s => s.grid.uniqueListsIsLoading);
        this.uniqueListsComplete$ = _store.select(s => s.grid.uniqueListsComplete);
        this.uniqueListsHasFailed$ = _store.select(s => s.grid.uniqueListsHasFailed);
    }

    requestUniqueList(scenarioId: number, colId: string) {
        this._store.dispatch(new GridActions.RequestUniqueList(scenarioId, colId));
    }
    
}