import { ScenariosState, ScenariosReducer} from './scenarios.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../app/app.reducer';

export interface ScenariosState extends AppState {
    scenarios: ScenariosState
}

export const scenariosReducer = { scenarios: ScenariosReducer };
