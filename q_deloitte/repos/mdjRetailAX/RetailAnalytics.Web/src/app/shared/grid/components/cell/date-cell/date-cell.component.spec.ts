import { LocalizationModule } from 'angular-l10n';
import { DateCellComponent } from './date-cell.component';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

describe('DateCellComponent', () => {
  let component: any;
  let fixture: ComponentFixture<DateCellComponent>;
  let nativeElement: HTMLElement | null;
  let model;

   beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DateCellComponent ],
      imports: [LocalizationModule.forRoot(),]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DateCellComponent);
    component = fixture.componentInstance;
    component.params = {
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
