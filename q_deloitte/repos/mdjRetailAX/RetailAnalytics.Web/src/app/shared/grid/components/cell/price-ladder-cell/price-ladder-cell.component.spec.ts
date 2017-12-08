import { LocalizationModule } from 'angular-l10n';
import { PriceLadderCellComponent } from './price-ladder-cell.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { NgbBootstrapModule } from '../../../../ngbBootstrap/ngbBootstrap.module';

describe('NumberCellComponent', () => {
  let component: any;
  let fixture: ComponentFixture<PriceLadderCellComponent>;
  let nativeElement: HTMLElement | null;
  let model;

   beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ PriceLadderCellComponent ],
      imports: [
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        NgbBootstrapModule
      ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(PriceLadderCellComponent);
    component = fixture.componentInstance;
    component.params = {
      node: {
        data: {
          propertyToFind: 99
        }
      },
      column: {
        colId: 'discount2'
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

});
