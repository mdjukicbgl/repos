import { resetFakeAsyncZone } from '@angular/core/testing/src/testing';
import { Injectable } from '@angular/core';
import { Headers } from '@angular/http';
import { AuthHttp } from 'angular2-jwt';
import { Actions, Effect, toPayload } from '@ngrx/effects';
import { Action } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { environment } from '../../../../environments/environment';
import * as UploadActions from '../actions/upload.actions';
import { FileUpload } from '../models/file-upload.enum';

@Injectable()
export class UploadEffects {

  @Effect() $requestPreSignedUrl = this.actions$
  .ofType(UploadActions.ActionTypes.REQUEST_PRESIGNED_URL)
  .map((x: any)  => {
    return {
      type: FileUpload.ProductHierarchy,
      name: encodeURIComponent((x as any).file.name),
      size: (x as any).file.size,
      lastModifiedDate: new Date((x as any).file.lastModified).toISOString(),
    };
  })
  .switchMap(payload => this.http.post(environment.endpoint + '/api/upload/authorize?type=' + payload.type + '&name=' +
    payload.name + '&size=' + payload.size + '&lastModifiedDate=' + payload.lastModifiedDate, {},
    { headers: new Headers({ 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }) })
    .map(res => ({ type: UploadActions.ActionTypes.REQUEST_PRESIGNED_URL_COMPLETE, payload: res.json() }))
    .catch(() => Observable.of({ type: UploadActions.ActionTypes.REQUEST_PRESIGNED_URL_FAILED }))
  );

  @Effect() $uploadSuccess = this.actions$
    .ofType(UploadActions.ActionTypes.SEND_UPLOAD_SUCCESS)
    .map((x: any)  => {
      return {
        guid: (x as any).guid
      };
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/upload/finish/' + payload.guid)
      .map(res => ({ type: UploadActions.ActionTypes.SEND_UPLOAD_SUCCESS_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: UploadActions.ActionTypes.SEND_UPLOAD_SUCCESS_FAILED }))
    );

  @Effect() $uploadFailure = this.actions$
    .ofType(UploadActions.ActionTypes.SEND_UPLOAD_FAILURE)
    .map((x: any)  => {
      return {
        guid: (x as any).guid
      };
    })
    .switchMap(payload => this.http.get(environment.endpoint + '/api/upload/abort/' + payload.guid)
      .map(res => ({ type: UploadActions.ActionTypes.SEND_UPLOAD_FAILURE_COMPLETE, payload: res.json() }))
      .catch(() => Observable.of({ type: UploadActions.ActionTypes.SEND_UPLOAD_FAILURE_FAILED }))
    );

  constructor(
    private http: AuthHttp,
    private actions$: Actions
  ) { }

}

