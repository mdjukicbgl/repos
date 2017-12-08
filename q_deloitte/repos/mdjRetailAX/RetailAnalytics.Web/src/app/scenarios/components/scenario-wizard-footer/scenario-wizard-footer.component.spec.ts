import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ScenarioWizardFooterComponent } from './scenario-wizard-footer.component';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

describe('ScenarioWizardFooterComponent', () => {
  let component: ScenarioWizardFooterComponent;
  let fixture: ComponentFixture<ScenarioWizardFooterComponent>;
  let nativeElement: any;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
      ],
      declarations: [ ScenarioWizardFooterComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioWizardFooterComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should raise the save event on click', () => {
    spyOn(component.onSaveClick, 'emit');
    let button = nativeElement.querySelector('#saveButton');
    button.dispatchEvent(new Event('click'));
    fixture.detectChanges();
    expect(component.onSaveClick.emit).toHaveBeenCalled();
  });
});
