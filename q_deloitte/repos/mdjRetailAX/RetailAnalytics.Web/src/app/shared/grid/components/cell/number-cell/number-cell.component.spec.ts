import { LocalizationModule } from 'angular-l10n';
import { NumberCellComponent } from './number-cell.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

describe('NumberCellComponent', () => {
  let component: any;
  let fixture: ComponentFixture<NumberCellComponent>;
  let nativeElement: HTMLElement | null;
  let model;

   beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NumberCellComponent ],
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
    fixture = TestBed.createComponent(NumberCellComponent);
    component = fixture.componentInstance;
    component.params = {
      node: {
        data: {
          propertyToFind: 99
        }
      },
      context: {
        componentParent: {
          localeUtil: {
            getCurrentLocale: () => {}
          }
        }
      }
    }
    nativeElement = fixture.nativeElement;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should fetch the locale on init', () => {
    spyOn(component.params.context.componentParent.localeUtil, 'getCurrentLocale');
    component.agInit(component.params);
    expect(component.params.context.componentParent.localeUtil.getCurrentLocale).toHaveBeenCalled();
  });

  it('should display an alternative to zero if params are present', () => {
    component.showNoValueString = false;
    let hasNoValue = component.hasNoValueString();
    expect(hasNoValue).toEqual(false);
    component.showNoValueString = false;
    component.params.showNoValueStringProperty = 'propertyToFind';
    hasNoValue = component.hasNoValueString();
    expect(hasNoValue).toEqual(false);
    component.showNoValueString = false;
    component.params.showNoValueStringProperty = 'propertyToFind';
    component.params.showNoValueStringValues = [99];
    hasNoValue = component.hasNoValueString();
    expect(hasNoValue).toEqual(true);
  });

});
