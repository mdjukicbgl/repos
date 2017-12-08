import { BehaviorSubject, Observable } from 'rxjs/Rx';
import { UploadModel } from '../../models/upload.model';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { AlertsModule } from '../../../alerts/alerts.module';
import { FileUploadComponent } from './file-upload.component';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

class MockUploadModel {
  preSignedUrlSource = new BehaviorSubject<Object>('www.endpoint.com');
  preSignedUrl$: Observable<Object> = this.preSignedUrlSource.asObservable();

  preSignedUrlIsLoadingSource = new BehaviorSubject<boolean>(false);
  preSignedUrlIsLoading$: Observable<boolean> = this.preSignedUrlIsLoadingSource.asObservable();

  preSignedUrlHasFailedSource = new BehaviorSubject<boolean>(false);
  preSignedUrlHasFailed$: Observable<boolean> = this.preSignedUrlHasFailedSource.asObservable();

  requestPreSignedUrl(file: File) {
    this.preSignedUrlSource.next({});
  }
  sendUploadSuccess(guid: string) {

  }
  sendUploadFailure(guid: string) {

  }
}

describe('FileUploadComponent', () => {
  let component: FileUploadComponent;
  let fixture: ComponentFixture<FileUploadComponent>;
  let nativeElement: HTMLElement | null;
  let model;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        AlertsModule,
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
      ],
      declarations: [ FileUploadComponent ]
    })
    .overrideComponent(FileUploadComponent, {
      set: {
        providers: [
          { provide: UploadModel, useClass: MockUploadModel }
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FileUploadComponent);
    component = fixture.componentInstance;
    model = fixture.debugElement.injector.get(UploadModel);
    nativeElement = fixture.debugElement.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should clear error messages', () => {
    component.errors.push('error1');
    component.successes.push('success1');
    expect(component.errors.length).toBe(1);
    expect(component.successes.length).toBe(1);
    component.clearMessages();
    expect(component.errors.length).toBe(0);
    expect(component.successes.length).toBe(0);
  });

  it('should handle a dropped file and request a pre signed Url', () => {
    let mockDropEvent = {
      type: 'drop',
      preventDefault: jasmine.createSpy('preventdefault'),
      dataTransfer: { files: [new File([''],'filename.txt', {type: 'text/plain'})] }
    };
    spyOn(model, 'requestPreSignedUrl');
    component.handleDrop(mockDropEvent);
    expect(mockDropEvent.preventDefault).toHaveBeenCalled();
    expect(model.requestPreSignedUrl).toHaveBeenCalled();
  });

  it('should reject any non text/* files', () => {
    let mockDropEvent = {
      type: 'drop',
      preventDefault: jasmine.createSpy('preventdefault'),
      dataTransfer: { files: [new File([''], 'filename.jpeg', {type: 'image/jpeg'})] }
    };
    spyOn(model, 'requestPreSignedUrl');
    component.handleDrop(mockDropEvent);
    expect(mockDropEvent.preventDefault).toHaveBeenCalled();
    expect(model.requestPreSignedUrl).not.toHaveBeenCalled();
    expect(component.errors.length).toBe(1);
  });

  it('should accept a file with extension csv with a non text mime type', () => {
    let mockDropEvent = {
      type: 'drop',
      preventDefault: jasmine.createSpy('preventdefault'),
      dataTransfer: { files: [new File([""], "filename.csv", {type: "image/jpeg"})] }
    };
    spyOn(model, 'requestPreSignedUrl');
    component.handleDrop(mockDropEvent);
    expect(mockDropEvent.preventDefault).toHaveBeenCalled();
    expect(model.requestPreSignedUrl).toHaveBeenCalled();
    expect(component.errors.length).toBe(0);
  });

  it('should accept a file with extension csv with a text mime type', () => {
    let mockDropEvent = {
      type: 'drop',
      preventDefault: jasmine.createSpy('preventdefault'),
      dataTransfer: { files: [new File([""], "filename.csv", {type: "text/csv"})] }
    };
    spyOn(model, 'requestPreSignedUrl');
    component.handleDrop(mockDropEvent);
    expect(mockDropEvent.preventDefault).toHaveBeenCalled();
    expect(model.requestPreSignedUrl).toHaveBeenCalled();
    expect(component.errors.length).toBe(0);
  });

  it('should exit if no file included', () => {
    let mockDropEvent = {
      type: 'drop',
      preventDefault: jasmine.createSpy('preventdefault'),
      dataTransfer: { files: [] }
    };
    spyOn(model, 'requestPreSignedUrl');
    component.handleDrop(mockDropEvent);
    expect(mockDropEvent.preventDefault).toHaveBeenCalled();
    expect(model.requestPreSignedUrl).not.toHaveBeenCalled();
  });

  it('should send a success message if successful', () => {
    spyOn(model, 'sendUploadSuccess');
    component.guid = 'abc';
    component.loading = true;
    expect(component.successes.length).toBe(0);
    component.transferComplete({});
    expect(model.sendUploadSuccess).toHaveBeenCalledWith('abc');
    expect(component.successes.length).toBe(1);
    expect(component.loading).toBe(false);
  });

  it('should send a failure message if failure', () => {
    spyOn(model, 'sendUploadFailure');
    component.guid = 'abc';
    component.loading = true;
    expect(component.errors.length).toBe(0);
    component.transferFailed({});
    expect(model.sendUploadFailure).toHaveBeenCalledWith('abc');
    expect(component.errors.length).toBe(1);
    expect(component.loading).toBe(false);
  });

  it('should send a success message if cancelled', () => {
    spyOn(model, 'sendUploadFailure');
    component.guid = 'abc';
    component.loading = true;
    expect(component.errors.length).toBe(0);
    component.transferCanceled({});
    expect(model.sendUploadFailure).toHaveBeenCalledWith('abc');
    expect(component.errors.length).toBe(1);
    expect(component.loading).toBe(false);
  });



});
