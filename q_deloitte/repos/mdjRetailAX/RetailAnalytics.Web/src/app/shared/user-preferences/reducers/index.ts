import { UserPreferencesReducer, UserPreferencesState } from './user-preferences.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../../app/app.reducer';

export interface UserPreferencesState extends AppState {
    userPreferences: UserPreferencesState;
}

export const userPreferencesReducer = { userPreferences:  UserPreferencesReducer };
