import { ActionReducer, combineReducers, Action, State } from '@ngrx/store';
import { RouterState, routerReducer } from '@ngrx/router-store';


export interface AppState {
    router: RouterState;
}

export const appReducer = {
    router: routerReducer
};
