import { GridState, GridReducer } from './grid.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../../app/app.reducer';

export interface GridState extends AppState {
    grid: GridState;
}

export const gridReducer = { grid: GridReducer };
