import '@ngrx/core/add/operator/select';
import { Observable } from 'rxjs/Observable';
import { AppState } from '../../../../app/app.reducer';
import { ActionReducer, Action } from '@ngrx/store';
import * as UserPreferencesActions from '../actions/user-preferences.actions';

export interface UserPreferencesState {
    gridStates: Array<State>;
    sortStates: Array<State>;
    lastScenarioId: number;
}

export const initialState: UserPreferencesState = {
    gridStates: [],
    sortStates: [],
    lastScenarioId: null
}

export const loadedState: UserPreferencesState = JSON.parse(localStorage.getItem('userPreferences'));

export function UserPreferencesReducer(state: UserPreferencesState = loadedState || initialState, action: any) {
    switch (action.type) {
        case UserPreferencesActions.ActionTypes.SET_GRID_STATE: {
            state.gridStates = updateStates(state.gridStates, new State(action.route, action.state));
            updateLocalStorage(state);
            return {
                ...state,
            }
        }
        case UserPreferencesActions.ActionTypes.CLEAR_GRID_STATE: {
            state.gridStates = removeState(state.gridStates, action.route);
            updateLocalStorage(state);
            return {
                ...state,
            }
        }
        case UserPreferencesActions.ActionTypes.SET_SORT_STATE: {
            state.sortStates = updateStates(state.sortStates, new State(action.route, action.state));
            updateLocalStorage(state);
            return {
                ...state,
            }
        }
        case UserPreferencesActions.ActionTypes.CLEAR_SORT_STATE: {
            state.sortStates = removeState(state.sortStates, action.route);
            updateLocalStorage(state);
            return {
                ...state,
            }
        }
        case UserPreferencesActions.ActionTypes.SET_LAST_WORKSPACE: {
            state.lastScenarioId = action.scenarioId;
            updateLocalStorage(state);
            return {
                ...state
            }
        }
        default:
            return state;
    }
}

export function updateLocalStorage(state) {
    localStorage.setItem('userPreferences', JSON.stringify(state));
}

export function updateStates(states: Array<State>, updatedState: State) {
    let newStateObject = states.map(x => Object.assign({}, x));
    let objIndex = newStateObject.
                    findIndex((gridState => 
                    gridState.route === updatedState.route));
    if (objIndex === -1) {
        newStateObject.push(updatedState);
    } else {
        newStateObject[objIndex] = updatedState;
    }
    return newStateObject;
}

export function removeState(states: Array<State>, route: string) {
    let objIndex = states.
                    findIndex((gridState => 
                    gridState.route === route));
    if (objIndex === -1 || states.length === 0) {
        return states;
    } else {
        states.splice(objIndex, 1);
        return states;
    }
}
 
export class State {
    route: string;
    state: Object;

    constructor(route: string, state: Object) {
        this.route = route;
        this.state = state;
    }
}