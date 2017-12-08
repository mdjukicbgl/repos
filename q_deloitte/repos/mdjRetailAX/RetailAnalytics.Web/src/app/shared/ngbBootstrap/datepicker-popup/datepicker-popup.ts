import { LocaleUtil } from '../../utils/locale-util/locale-util';
import { TranslateService } from '@ngx-translate/core';
import { Subscription } from 'rxjs/Rx';
import { NgbDate } from '@ng-bootstrap/ng-bootstrap/datepicker/ngb-date';
import { Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { NgbDateStruct } from "@ng-bootstrap/ng-bootstrap/datepicker/ngb-date-struct";

@Component({
  selector: 'ngbd-datepicker-popup',
  templateUrl: 'datepicker-popup.html'
})
export class NgbdDatepickerPopup implements OnInit, OnDestroy {

  @Input() model: NgbDateStruct;
  @Input() minDate: NgbDateStruct;
  @Output() dateChange: EventEmitter<any> = new EventEmitter();

  locale: string;
  date: NgbDate;

  private _subscriptions: Array<Subscription> = [];


  constructor(
    private translate: TranslateService,
    private localeUtil: LocaleUtil) {
  }

  ngOnInit() {
    this._subscriptions.push(this.translate.onLangChange.subscribe(() => {
      this.locale = this.localeUtil.getCurrentLocale();
    }));
    this.locale = this.localeUtil.getCurrentLocale();
  }

  onUpdateModel($event){
    this.date = new NgbDate($event.year,$event.month,$event.day)
    this.dateChange.emit($event);
  }

  onClearDate() {
    this.date = null;
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }
}
