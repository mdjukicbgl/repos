import { UploadState, UploadReducer} from './upload.reducer';
import { combineReducers, Action, ActionReducer } from '@ngrx/store';
import { compose } from '@ngrx/core/compose';
import { AppState } from '../../../../app/app.reducer';

export interface UploadState extends AppState {
    upload: UploadState;
}

export const uploadReducer = { upload: UploadReducer };
