import { CalendarWeeksModel } from '../../models/calendar-weeks.model';
import { CalendarWeeks, Week } from '../../models/calendar-weeks.entity';
import { Observable, Subscription } from 'rxjs/Rx';
import { Component, OnInit, AfterViewInit, OnDestroy, EventEmitter, Output, ChangeDetectionStrategy } from '@angular/core';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap/datepicker/ngb-date';
import { NgbDateStruct } from "@ng-bootstrap/ng-bootstrap/datepicker/ngb-date-struct";
import { TranslateService } from "@ngx-translate/core";
import { LocaleUtil } from "../../../utils/locale-util/locale-util";

@Component({
  selector: 'app-calendar-weeks',
  templateUrl: './calendar-weeks.component.html',
  styleUrls: ['./calendar-weeks.component.scss'],
  providers: [ CalendarWeeksModel ],
})
export class CalendarWeeksComponent implements OnInit, OnDestroy {

  @Output() selectedWeeksChange: EventEmitter<any> = new EventEmitter();

  calendarWeeks$: Observable<CalendarWeeks>;
  calendarWeeksIsLoading$: Observable<boolean>;
  calendarWeeksHasLoadingFailed$: Observable<boolean>;
  calendarWeeks: CalendarWeeks;

  selectedStartDate: number;
  selectedWeeks: string;
  minNumberOfWeeks: number = 1;
  maxNumberOfWeeks: number = 8;
  selectedNumberOfWeeks: number = 8;
  locale: string;
  today: NgbDateStruct;

  private _subscriptions: Array<Subscription> = [];

  constructor(
    private _model: CalendarWeeksModel,
    private translate: TranslateService,
    private localeUtil: LocaleUtil) {
    this.calendarWeeks$ = _model.calendarWeeks$;
    this.calendarWeeksIsLoading$ = _model.calendarWeeksIsLoading$;
    this.calendarWeeksHasLoadingFailed$ = _model.calendarWeeksHasLoadingFailed$;
  }

  ngOnInit() {

    this._subscriptions.push(this.calendarWeeks$.skip(1).subscribe((weeks) => {
        this.calendarWeeks = this.formatDisplayDate(weeks);
    }));
    this.setMinDate();

    this._subscriptions.push(this.translate.onLangChange.subscribe(() => {
      this.locale = this.localeUtil.getCurrentLocale();
    }));
    this.locale = this.localeUtil.getCurrentLocale();

  }

  setMinDate() {
    let d = new Date();
    this.today = {year: d.getFullYear(), month: d.getMonth() + 1, day: d.getDate()}
  }

  loadCalendarWeeks() {
    if (this.selectedStartDate && this.selectedNumberOfWeeks) {
      this._model.loadCalendarWeeks(this.selectedStartDate, this.selectedNumberOfWeeks);
    }
  }

  formatDisplayDate(calendarWeeks: CalendarWeeks) {
    calendarWeeks.weeks.forEach((week) => {
      week.friendlyDate = new Date(week.weekStart*1000).toDateString();
    });
    return calendarWeeks;
  }

  updateDate(date: NgbDate) {
    this.selectedStartDate = new Date(`${date.year}-${date.month}-${date.day}`).getTime() / 1000;
    this.loadCalendarWeeks();
  }

  formatSelectedWeeks(){
    let tmpSelectedWeeks: string = '';
    this.calendarWeeks.weeks.forEach( (week) => {
      tmpSelectedWeeks += week.selected ? 1 : 0;
    });
    tmpSelectedWeeks = tmpSelectedWeeks.split('').reverse().join('');
    this.selectedWeeks = tmpSelectedWeeks;
  }

  onSelectedWeeksChange() {
    this.formatSelectedWeeks();
    this.selectedWeeksChange.emit(this.selectedWeeks);
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }

}
