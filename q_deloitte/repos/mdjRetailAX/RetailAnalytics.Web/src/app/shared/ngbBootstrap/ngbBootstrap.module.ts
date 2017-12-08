import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { NgbDatepickerModule } from '@ng-bootstrap/ng-bootstrap/datepicker/datepicker.module';
import { NgbModalModule } from '@ng-bootstrap/ng-bootstrap/modal/modal.module';
import { NgbTabsetModule } from '@ng-bootstrap/ng-bootstrap/tabset/tabset.module';
import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap/dropdown/dropdown.module';
import { NgbPopoverModule } from '@ng-bootstrap/ng-bootstrap/popover/popover.module';

import { LocalizationModule } from 'angular-l10n';
import { TranslateModule } from '@ngx-translate/core';

import { NgbdDatepickerPopup } from './datepicker-popup/datepicker-popup';

@NgModule({
  imports: [
      CommonModule,
      FormsModule,
      NgbDatepickerModule.forRoot(),
      NgbModalModule.forRoot(),
      NgbTabsetModule.forRoot(),
      NgbDropdownModule.forRoot(),
      NgbPopoverModule.forRoot(),
      LocalizationModule,
      TranslateModule
    ],
  declarations: [
    NgbdDatepickerPopup
  ],
  exports: [
    NgbdDatepickerPopup,
    NgbDatepickerModule,
    NgbModalModule,
    NgbTabsetModule,
    NgbDropdownModule,
    NgbPopoverModule
  ],
})

export class NgbBootstrapModule {}
