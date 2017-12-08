import '@ngrx/core/add/operator/select';
import { Observable } from 'rxjs/Observable';
import { AppState } from '../../../../app/app.reducer';
import { ActionReducer, Action } from '@ngrx/store';
import * as UploadActions from '../actions/upload.actions';

export interface UploadState {
    preSignedUrl: string;
    preSignedUrlIsLoading: boolean;
    preSignedUrlHasFailed: boolean;
}

export const initialState: UploadState = {
    preSignedUrl: null,
    preSignedUrlIsLoading: false,
    preSignedUrlHasFailed: false,
};

export function UploadReducer(state: UploadState = initialState, action: Action): UploadState {
  switch (action.type) {

    case UploadActions.ActionTypes.REQUEST_PRESIGNED_URL: {
        return {
            ...state,
            preSignedUrlIsLoading: true,
            preSignedUrlHasFailed: false,
        };
    }
    case UploadActions.ActionTypes.REQUEST_PRESIGNED_URL_COMPLETE: {
        return {
            ...state,
            preSignedUrl: action.payload,
            preSignedUrlIsLoading: false,
            preSignedUrlHasFailed: false,
        };
    }
    case UploadActions.ActionTypes.REQUEST_PRESIGNED_URL_FAILED: {
        return {
            ...state,
            preSignedUrl: '',
            preSignedUrlIsLoading: false,
            preSignedUrlHasFailed: true,
        };
    }
    default:
        return state;
  }
}
