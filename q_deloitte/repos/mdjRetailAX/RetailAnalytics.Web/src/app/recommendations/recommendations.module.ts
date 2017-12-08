import { LocaleUtil } from '../shared/utils/locale-util/locale-util';
import { AlertsModule } from '../shared/alerts/alerts.module';
import { UploadModule } from '../shared/upload/upload.module';
import { CalendarWeeksModule } from '../shared/calendar-weeks/calendar-weeks.module';
import { NgbBootstrapModule } from '../shared/ngbBootstrap/ngbBootstrap.module';
import { HttpModule } from '@angular/http';
import { Routes, RouterModule } from '@angular/router';
import { NavigationModule } from '../shared/navigation/navigation.module';
import { RecommendationsRoutingModule } from './recommendations-routing.module';
import { StoreMgmtModule } from '../shared/store-mgmt/store-mgmt.module';
import { NgSpinKitModule } from 'ng-spin-kit';

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { CommonModule } from '@angular/common';
import { EffectsModule } from '@ngrx/effects';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RecommendationsComponent } from './recommendations.component';
import { ScenarioWorkspaceComponent } from './components/scenario-workspace/scenario-workspace.component';
import { RecommendationsEffects } from './effects/recommendations.effects';

import { ScenariosModel } from '../scenarios/models/scenarios.model';

import { WindowSize } from '../shared/utils/window-size/window-size';
import { ErrorGroupComponent } from "../shared/alerts/error-group/error-group.component";
import { ScenarioWorkspaceFooterComponent } from './components/scenario-workspace-footer/scenario-workspace-footer.component';
import { ScenarioWorkspaceNotificationsComponent } from './components/scenario-workspace-notifications/scenario-workspace-notifications.component';
import { ScenarioWorkspaceTotalsComponent } from './components/scenario-workspace-totals/scenario-workspace-totals.component';
import { TranslateModule } from "@ngx-translate/core";
import { GridModule } from '../shared/grid/grid.module';
import { AgGridModule } from 'ag-grid-angular/main';
import { LicenseManager } from "ag-grid-enterprise/main";
LicenseManager.setLicenseKey('ag-Grid_Evaluation_License_Not_for_Production_100Devs26_July_2017__MTUwMTAyMzYwMDAwMA==d8b073e5adc2a2e1debe4e10d508e42c');
import { LocalizationModule } from 'angular-l10n';
import { RecommendationsModel } from "./models/recommendations.model";
import { UserPreferencesModule } from '../shared/user-preferences/user-preferences.module';
import { ReviseService } from './services/revise.service';
import { WorkspacePreferencesService } from './services/workspace-preferences.service';

import {
  StatusCellComponent,
  DateCellComponent,
  ApproveCellComponent,
  StringFilterComponent,
  NumberFilterComponent,
  NumberCellEditComponent,
  SetFilterComponent,
  NumberCellComponent,
  SimpleHeaderComponent,
  DateFilterComponent,
  FreezeTabComponent,
  ShowHideTabComponent,
  StandardHeaderComponent,
  ApproveHeaderComponent,
  PriceLadderCellComponent,
  PriceLadderCellEditComponent,
  PercentageCellComponent,
  CurrencyCellComponent,
  EmptyHeaderComponent,
  StringListFilterComponent } from '../shared/grid';

@NgModule({
    imports: [
        CommonModule,
        FormsModule,
        LocalizationModule,
        TranslateModule,
        RecommendationsRoutingModule,
        StoreMgmtModule,
        NgSpinKitModule,
        NavigationModule,
        NgbBootstrapModule,
        EffectsModule.run(RecommendationsEffects),
        GridModule,
        UploadModule,
        CalendarWeeksModule,
        UserPreferencesModule,
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
          NumberCellEditComponent,
          SimpleHeaderComponent,
          FreezeTabComponent,
          ShowHideTabComponent,
          StandardHeaderComponent,
          PriceLadderCellComponent,
          PriceLadderCellEditComponent,
          PercentageCellComponent,
          CurrencyCellComponent,
          EmptyHeaderComponent,
          StringListFilterComponent,
          ApproveHeaderComponent
        ]),
    ],
    declarations: [
        RecommendationsComponent,
        ScenarioWorkspaceComponent,
        ScenarioWorkspaceFooterComponent,
        ScenarioWorkspaceNotificationsComponent,
        ScenarioWorkspaceTotalsComponent,
    ],
    providers: [
      WindowSize,
      LocaleUtil,
      ScenariosModel,
      ReviseService,
      WorkspacePreferencesService,
      RecommendationsModel,
    ]
})
export class RecommendationsModule { }