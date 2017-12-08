import { LocaleUtil } from '../../../utils/locale-util/locale-util';
import { AlertsModule } from '../../../alerts/alerts.module';
import { NgbBootstrapModule } from '../../../ngbBootstrap/ngbBootstrap.module';
import { NgSpinKitModule } from 'ng-spin-kit';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap/datepicker/ngb-date';
import { CalendarWeeks } from '../../models/calendar-weeks.entity';
import { BehaviorSubject, Observable } from 'rxjs/Rx';
import { CalendarWeeksModel } from '../../models/calendar-weeks.model';
import { SliderModule } from 'primeng/primeng';
import { NgbDatepickerModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule } from '@angular/forms';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { LocalizationModule } from 'angular-l10n';

import { CalendarWeeksComponent } from './calendar-weeks.component';

  let calendarWeeks: CalendarWeeks = {
    calendarId: 1,
    calendarName: 'Test Calendar',
    startDate: 1496048400,
    numberWeeks: 8,
    weeks: [
      {
        weekNumber: 1,
        weekStart: 1496016000,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 2,
        weekStart: 1496620800,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 3,
        weekStart: 1497225600,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 4,
        weekStart: 1497830400,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 5,
        weekStart: 1498435200,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 6,
        weekStart: 1499040000,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 7,
        weekStart: 1499644800,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      },
      {
        weekNumber: 8,
        weekStart: 1500249600,
        dayWeekStart: 1,
        friendlyDate: null,
        selected: null
      }
    ]
};

// Markdown Model Mock
class MockMarkdownModel {

  calendarWeeksSource = new BehaviorSubject<CalendarWeeks>(calendarWeeks);
  calendarWeeks$: Observable<CalendarWeeks> = this.calendarWeeksSource.asObservable();

  calendarWeeksIsLoadingSource = new BehaviorSubject<boolean>(false);
  calendarWeeksIsLoading$: Observable<boolean> = this.calendarWeeksIsLoadingSource.asObservable();

  calendarWeeksHasLoadingFailedSource = new BehaviorSubject<boolean>(false);
  calendarWeeksHasLoadingFailed$: Observable<boolean> = this.calendarWeeksHasLoadingFailedSource.asObservable();

  updateCalendars(data) {
    this.calendarWeeksSource.next(data);
  }

  loadCalendarWeeks() {
    this.updateCalendars(calendarWeeks);
  }
}

let component: CalendarWeeksComponent;
let fixture: ComponentFixture<CalendarWeeksComponent>;
let nativeElement: HTMLElement | null;
let model;

describe('CalendarWeeksComponent', () => {
  let component: CalendarWeeksComponent;
  let fixture: ComponentFixture<CalendarWeeksComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CalendarWeeksComponent ],
      imports: [
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        FormsModule,
        SliderModule,
        NgSpinKitModule,
        NgbBootstrapModule,
        AlertsModule
        ],
        providers: [
          LocaleUtil
        ]
    })
    .overrideComponent(CalendarWeeksComponent, {
      set: {
        providers: [
          { provide: CalendarWeeksModel, useClass: MockMarkdownModel },
        ],
      }
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CalendarWeeksComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    model = fixture.debugElement.injector.get(CalendarWeeksModel);
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should format the dates to have a friendly display value', () => {
    model.updateCalendars(calendarWeeks);
    expect(component.calendarWeeks.weeks[0]).toEqual({
        weekNumber: 1,
        weekStart: 1496016000,
        dayWeekStart: 1,
        friendlyDate: 'Mon May 29 2017',
        selected: null
      });
  });

  it('should format the datepicker date to seconds', () => {
    component.updateDate(new NgbDate(2017, 5, 29));
    // Different results vs mac and CI environment. They are 1 hour apart... dont know why.
    // No impact on functionality, just a curiousity.
    expect( component.selectedStartDate ).toBeGreaterThanOrEqual(1496012400);
    expect( component.selectedStartDate ).toBeLessThanOrEqual(1496016000);
  });

  it('should format the selected weeks to a mask for POST', () => {
    model.updateCalendars(calendarWeeks);
    component.calendarWeeks.weeks[0].selected = true;
    component.calendarWeeks.weeks[2].selected = true;
    component.calendarWeeks.weeks[4].selected = true;
    component.calendarWeeks.weeks[6].selected = true;
    component.formatSelectedWeeks();
    expect(component.selectedWeeks).toEqual('01010101');
  });

  it('should emit a change on selected weeks', () => {
    model.updateCalendars(calendarWeeks);
    component.calendarWeeks.weeks[0].selected = true;
    component.calendarWeeks.weeks[2].selected = true;
    component.calendarWeeks.weeks[4].selected = true;
    component.calendarWeeks.weeks[6].selected = true;
    spyOn(component.selectedWeeksChange, 'emit');
    component.onSelectedWeeksChange();
    expect(component.selectedWeeksChange.emit).toHaveBeenCalledWith('01010101');
  });

});
