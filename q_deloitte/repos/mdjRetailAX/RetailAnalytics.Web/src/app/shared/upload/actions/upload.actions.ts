import { Action } from '@ngrx/store';
import { type } from '../../utils/type';

export const ActionTypes = {
    REQUEST_PRESIGNED_URL: type('[Upload] Request Pre Signed Url'),
    REQUEST_PRESIGNED_URL_COMPLETE: type('[Upload] Request Pre Signed Url Complete'),
    REQUEST_PRESIGNED_URL_FAILED: type('[Upload] Request Pre Signed Url Failed'),

    SEND_UPLOAD_SUCCESS: type('[Upload] Send Upload Success'),
    SEND_UPLOAD_SUCCESS_COMPLETE: type('[Upload] Send Upload Success Complete'),
    SEND_UPLOAD_SUCCESS_FAILED: type('[Upload] Send Upload Success Failed'),

    SEND_UPLOAD_FAILURE: type('[Upload] Send Upload Failure'),
    SEND_UPLOAD_FAILURE_COMPLETE: type('[Upload] Send Upload Failure Complete'),
    SEND_UPLOAD_FAILURE_FAILED: type('[Upload] Send Upload Failure Failed'),
};

export class RequestPreSignedUrl implements Action {
    type = ActionTypes.REQUEST_PRESIGNED_URL;

    constructor(public file: File) {}
}

export class SendUploadSuccess implements Action {
    type = ActionTypes.SEND_UPLOAD_SUCCESS;

    constructor(public guid: string) {}
}

export class SendUploadFailure implements Action {
    type = ActionTypes.SEND_UPLOAD_FAILURE;

    constructor(public guid: string) {}
}
