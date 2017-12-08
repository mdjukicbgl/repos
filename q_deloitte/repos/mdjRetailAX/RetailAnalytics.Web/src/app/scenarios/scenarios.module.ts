import { LocaleUtil } from '../shared/utils/locale-util/locale-util';
import { AlertsModule } from '../shared/alerts/alerts.module';
import { UploadModule } from '../shared/upload/upload.module';
import { CalendarWeeksModule } from '../shared/calendar-weeks/calendar-weeks.module';
import { NgbBootstrapModule } from '../shared/ngbBootstrap/ngbBootstrap.module';
import { HttpModule } from '@angular/http';
import { Routes, RouterModule } from '@angular/router';
import { NavigationModule } from '../shared/navigation/navigation.module';
import { ScenariosRoutingModule } from './scenarios-routing.module';
import { StoreMgmtModule } from '../shared/store-mgmt/store-mgmt.module';
import { UserPreferencesModule } from '../shared/user-preferences/user-preferences.module';
import { NgSpinKitModule } from 'ng-spin-kit';

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { EffectsModule } from '@ngrx/effects';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ScenariosComponent } from './scenarios.component';
import { ScenarioSummaryComponent } from './components/scenario-summary/scenario-summary.component';
import { ScenarioSummaryFooterComponent } from './components/scenario-summary-footer/scenario-summary-footer.component';
import { ScenarioEditComponent } from './components/scenario-edit/scenario-edit.component';
import { ScenariosEffects } from './effects/scenarios.effects';
import { PricePathPipe } from './pipes/price-path.pipe';
import { WindowSize } from '../shared/utils/window-size/window-size';
import { ErrorGroupComponent } from "../shared/alerts/error-group/error-group.component";
import { ScenarioWizardFooterComponent } from './components/scenario-wizard-footer/scenario-wizard-footer.component';
import { TranslateModule } from "@ngx-translate/core";
import { GridModule } from '../shared/grid/grid.module';
import { AgGridModule } from 'ag-grid-angular/main';
import { LicenseManager } from "ag-grid-enterprise/main";
LicenseManager.setLicenseKey('ag-Grid_Evaluation_License_Not_for_Production_100Devs26_July_2017__MTUwMTAyMzYwMDAwMA==d8b073e5adc2a2e1debe4e10d508e42c');
import { LocalizationModule } from 'angular-l10n';

import {
  StatusCellComponent,
  DateCellComponent,
  ApproveCellComponent,
  StringFilterComponent,
  NumberFilterComponent,
  SetFilterComponent,
  NumberCellComponent,
  SimpleHeaderComponent,
  DateFilterComponent,
  FreezeTabComponent,
  ShowHideTabComponent,
  StandardHeaderComponent,
  PercentageCellComponent,
  CurrencyCellComponent,
  CreateScenarioRendererComponent,
  EmptyHeaderComponent,
  WorkflowIndicatorCellComponent,
  ProductGroupDetailComponent,
  MeasureCellComponent,
  StringListFilterComponent
} from '../shared/grid';

@NgModule({
    imports: [
        CommonModule,
        FormsModule,
        LocalizationModule,
        TranslateModule,
        ScenariosRoutingModule,
        StoreMgmtModule,
        NgSpinKitModule,
        NavigationModule,
        NgbBootstrapModule,
        EffectsModule.run(ScenariosEffects),
        GridModule,
        UploadModule,
        CalendarWeeksModule,
        AlertsModule,
        AgGridModule.withComponents([
          StatusCellComponent,
          DateCellComponent,
          ApproveCellComponent,
          StringFilterComponent,
          NumberFilterComponent,
          SetFilterComponent,
          DateFilterComponent,
          NumberCellComponent,
          SimpleHeaderComponent,
          FreezeTabComponent,
          ShowHideTabComponent,
          StandardHeaderComponent,
          PercentageCellComponent,
          CurrencyCellComponent,
          CreateScenarioRendererComponent,
          EmptyHeaderComponent,
          WorkflowIndicatorCellComponent,
          ProductGroupDetailComponent,
          MeasureCellComponent,
          StringListFilterComponent
        ]),
        UserPreferencesModule
    ],
    declarations: [
        ScenariosComponent,
        ScenarioSummaryComponent,
        ScenarioEditComponent,
        ScenarioWizardFooterComponent,
        ScenarioSummaryFooterComponent,
        PricePathPipe,
    ],
    providers: [
      WindowSize,
      LocaleUtil
    ]
})
export class ScenariosModule { }
