import { SimpleHeaderComponent } from './simple-header.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { LocalizationModule } from 'angular-l10n';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

describe('SimpleHeaderComponent', () => {
  let component: any;
  let fixture: ComponentFixture<SimpleHeaderComponent>;
  let nativeElement: HTMLElement | null;
  let model;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SimpleHeaderComponent ],
      imports: [
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SimpleHeaderComponent);
    component = fixture.componentInstance;
    component.params = {
      suppressOffset: false,
      translationKey: 'translationKey'
    }
    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch its own header name', () => {
    spyOn(component, 'getHeaderName');
    component.agInit(component.params);
    expect(component.getHeaderName).toHaveBeenCalled();
  });

});
