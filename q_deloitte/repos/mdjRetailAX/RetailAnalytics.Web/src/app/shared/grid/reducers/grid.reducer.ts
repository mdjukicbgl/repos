import '@ngrx/core/add/operator/select';
import { Observable } from 'rxjs/Observable';
import { AppState } from '../../../../app/app.reducer';
import { ActionReducer, Action } from '@ngrx/store';
import { UniqueList } from '../models/unique-list.entity';
import * as GridActions from '../actions/grid.actions';

export interface GridState {
    uniqueLists: Array<UniqueList>;

    uniqueListsIsLoading: boolean;
    uniqueListsComplete: boolean;
    uniqueListsHasFailed: boolean;
}

export const initialState: GridState = {
    uniqueLists: [],

    uniqueListsIsLoading: false,
    uniqueListsComplete: false,
    uniqueListsHasFailed: false
};

export function GridReducer(state: GridState = initialState, action: Action) {
    switch (action.type) {
        case GridActions.ActionTypes.REQUEST_UNIQUE_LIST: {
            return {
                ...state,
                uniqueListsIsLoading: true,
                uniqueListsComplete: false,
                uniqueListsHasFailed: false
            }
        }
        case GridActions.ActionTypes.REQUEST_UNIQUE_LIST_COMPLETE: {
            return {
                ...state,
                uniqueLists: updateList(state.uniqueLists, new UniqueList(action.payload.colId, action.payload.list)),
                uniqueListsIsLoading: false,
                uniqueListsComplete: true,
                uniqueListsHasFailed: false
            }
        }
        case GridActions.ActionTypes.REQUEST_UNIQUE_LIST_FAILED: {
            return {
                ...state,
                uniqueListsIsLoading: false,
                uniqueListsComplete: false,
                uniqueListsHasFailed: true
            }
        }
        default:
            return state;
    }
}

export function updateList(uniqueLists: Array<UniqueList>, updatedList: UniqueList) {
    let newUniqueLists = uniqueLists.map(x => Object.assign({}, x));
    let objIndex = newUniqueLists
        .findIndex(list => 
            list.colId === updatedList.colId);
    if (objIndex === -1) {
        newUniqueLists.push(updatedList);
    } else {
        newUniqueLists[objIndex] = updatedList;
    }
    return newUniqueLists;
}