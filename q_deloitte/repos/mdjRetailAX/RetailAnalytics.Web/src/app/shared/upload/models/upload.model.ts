import { Injectable } from '@angular/core';
import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';

import { UploadState, uploadReducer } from '../reducers/index';
import { StoreMgmtService } from '../../store-mgmt/store-mgmt.service';
import * as uploadActions from '../actions/upload.actions';

@Injectable()
export class UploadModel {

    preSignedUrl$: Observable<string>;
    preSignedUrlIsLoading$: Observable<boolean>;
    preSignedUrlHasFailed$: Observable<boolean>;

    constructor(protected _store: Store<UploadState>, storeMgmtService: StoreMgmtService) {

      storeMgmtService.addReducers(uploadReducer);

      this.preSignedUrl$ = this._store.select(s => s.upload.preSignedUrl);
      this.preSignedUrlIsLoading$ = this._store.select(s => s.upload.preSignedUrlIsLoading);
      this.preSignedUrlHasFailed$ = this._store.select(s => s.upload.preSignedUrlHasFailed);
    }

    requestPreSignedUrl(file: File) {
        this._store.dispatch(new uploadActions.RequestPreSignedUrl(file));
    }

    sendUploadSuccess(guid: string) {
        this._store.dispatch(new uploadActions.SendUploadSuccess(guid));
    }

    sendUploadFailure(guid: string) {
        this._store.dispatch(new uploadActions.SendUploadFailure(guid));
    }

}
