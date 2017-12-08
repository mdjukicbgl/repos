import { NgbBootstrapModule } from '../ngbBootstrap/ngbBootstrap.module';
import { EffectsModule } from '@ngrx/effects';
import { LocaleUtil } from '../utils/locale-util/locale-util';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CalendarWeeksEffects } from './effects/calendar-weeks.effects';
import { NgSpinKitModule } from 'ng-spin-kit';
import { SliderModule } from 'primeng/primeng';
import { TranslateModule } from "@ngx-translate/core";
import { CalendarWeeksComponent } from './components/calendar-weeks/calendar-weeks.component';
import { LocalizationModule } from 'angular-l10n';

@NgModule({
    imports: [
        CommonModule,
        FormsModule,
        NgSpinKitModule,
        EffectsModule.run(CalendarWeeksEffects),
        SliderModule,
        NgbBootstrapModule,
        LocalizationModule,
        TranslateModule,
    ],
    declarations: [
        CalendarWeeksComponent,
    ],
    exports: [
        CalendarWeeksComponent,
    ],
})
export class CalendarWeeksModule { }
