import { XHRConnection } from '@angular/http';
import { UploadModel } from '../../models/upload.model';
import { Observable, Subscription } from 'rxjs/Rx';
import { Component, EventEmitter, Input, OnInit, OnDestroy, Output, ViewChild } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'file-upload',
    templateUrl: './file-upload.component.html',
    styleUrls: ['./file-upload.component.scss'],
    providers: [ UploadModel]
})
export class FileUploadComponent implements OnInit, OnDestroy {

  @ViewChild('fileUpload') input;

  @Output() onFileUploaded: EventEmitter<any> = new EventEmitter();

  preSignedUrl$: Observable<string>;
  preSignedUrlIsLoading$: Observable<boolean>;
  preSignedUrlHasFailed$: Observable<boolean>;

  dragging = false;
  file: File;
  fileSrc = '';
  reader = new FileReader();
  progressComplete = 0;
  guid: string;
  xhr: any;

  loading: boolean = false;
  loaded: boolean = false;
  CSVExtension: string = 'csv';

  errors: Array<string> = [];
  successes: Array<string> = [];

  _subscriptions: Array<Subscription> = [];

  translations: String[];

  constructor(
    private _model: UploadModel,
    private translate: TranslateService
    ) {
    this.preSignedUrl$ = _model.preSignedUrl$;
    this.preSignedUrlIsLoading$ = _model.preSignedUrlIsLoading$;
    this.preSignedUrlHasFailed$ = _model.preSignedUrlHasFailed$;
  }

  ngOnInit() {
    this.observePreSignedUrl();
    this.getTranslations();
    this._subscriptions.push(this.translate.onLangChange.subscribe(() => {
      this.getTranslations();
    }));
  }

  getTranslations() {
    this._subscriptions.push(this.translate.get([
      'UPLOAD.UPLOAD_SUCCESSFUL',
      'UPLOAD.UPLOAD_FAILED',
      'UPLOAD.UPLOAD_CANCELLED',
      'UPLOAD.INVALID_FILE_TYPE',
    ]).subscribe((res: string[]) => {
        this.translations = res;
    }));
  }

  clearMessages() {
    this.errors = [];
    this.successes = [];
  }

  clearPreviousFile() {
    this.input.nativeElement.value = null;
  }

  observePreSignedUrl() {
    this._subscriptions.push(this.preSignedUrl$.skip(1).subscribe((uploadDetails: any) => {
      this.guid = uploadDetails.guid;
      this.xhr = this.uploadFile(uploadDetails);
    }));
  }

  handleDragEnter() {
    this.dragging = true;
  }

  handleDragLeave() {
    this.dragging = false;
  }

  handleDrop($event) {
    $event.preventDefault();
    this.dragging = false;
    this.handleInputChange($event);
    this.clearPreviousFile();
  }

  handleInputChange($event) {
    this.clearMessages();
    this.loaded = false;
    this.file = $event.dataTransfer ? $event.dataTransfer.files[0] : $event.target.files[0];
    let pattern = /text-*/;

    if ( !this.file ) {
      return;
    }

    let fileExt = this.file.name.split('.').pop();

    if (!this.file.type.match(pattern) && fileExt.toLowerCase() !== this.CSVExtension) {
      this.errors.push(this.translations['UPLOAD.INVALID_FILE_TYPE']);
      return;
    }

    this._model.requestPreSignedUrl(this.file);
  }

  onCancelUpload() {
    if ( this.xhr ) {
      this.xhr.abort();
    }
  }

  uploadFile(uploadDetails) {
    let xhr = new XMLHttpRequest();
    if ( xhr.upload ) {
      xhr.upload.addEventListener('progress', event => this.updateProgress(event));
    }
    xhr.addEventListener('load', event => this.transferComplete(event));
    xhr.addEventListener('error', event => this.transferFailed(event));
    xhr.addEventListener('abort', event => this.transferCanceled(event));
    xhr.open('PUT', uploadDetails.url);
    this.loading = true;
    xhr.send(this.file);
    return xhr;
  }

  updateProgress($event) {
    if ($event.lengthComputable) {
     this.progressComplete = ($event.loaded / $event.total) * 100;
    }
  }

  transferComplete($event) {
    this.loading = false;
    this.loaded = true;
    this.successes.push(this.translations['UPLOAD.UPLOAD_SUCCESSFUL']);
    this._model.sendUploadSuccess(this.guid);
    this.onFileUploaded.emit(this.guid);
  }

  transferFailed($event) {
    this.loading = false;
    this.errors.push(this.translations['UPLOAD.UPLOAD_FAILED']);
    this._model.sendUploadFailure(this.guid);
  }

  transferCanceled($event) {
    this.loading = false;
    this.errors.push(this.translations['UPLOAD.UPLOAD_CANCELLED']);
    this._model.sendUploadFailure(this.guid);
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }
}
