import { SlideToggleModule } from '../slide-toggle/slide-toggle.module';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { TranslateModule } from '@ngx-translate/core';
import { LocalizationModule } from 'angular-l10n';
import { NgbBootstrapModule } from '../ngbBootstrap/ngbBootstrap.module';
import { EffectsModule } from '@ngrx/effects';
import { GridEffects } from './effects/grid.effects';
import { NgSpinKitModule } from 'ng-spin-kit';

import {
  ApproveCellComponent,
  PercentageCellComponent,
  DateCellComponent,
  NumberCellEditComponent,
  NumberCellComponent,
  CurrencyCellComponent,
  PriceLadderCellComponent,
  PriceLadderCellEditComponent,
  StatusCellComponent,
  DateFilterComponent,
  NumberFilterComponent,
  SetFilterComponent,
  FreezeTabComponent,
  ShowHideTabComponent,
  StringFilterComponent,
  SimpleHeaderComponent,
  StandardHeaderComponent,
  CreateScenarioRendererComponent,
  EmptyHeaderComponent,
  WorkflowIndicatorCellComponent,
  ProductGroupDetailComponent,
  MeasureCellComponent,
  StringListFilterComponent,
  ApproveHeaderComponent
} from './index';

import { GridUtils } from './utils/grid-utils';
import { ServerParamsUtils } from './utils/server-params-utils';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    NgbBootstrapModule,
    LocalizationModule,
    TranslateModule,
    SlideToggleModule,
    EffectsModule.run(GridEffects),
    NgSpinKitModule
  ],
  declarations: [
    ApproveCellComponent,
    DateCellComponent,
    DateFilterComponent,
    NumberFilterComponent,
    NumberCellComponent,
    NumberCellEditComponent,
    SetFilterComponent,
    StatusCellComponent,
    StringFilterComponent,
    SimpleHeaderComponent,
    FreezeTabComponent,
    ShowHideTabComponent,
    StandardHeaderComponent,
    PriceLadderCellComponent,
    PriceLadderCellEditComponent,
    PercentageCellComponent,
    CurrencyCellComponent,
    CreateScenarioRendererComponent,
    EmptyHeaderComponent,
    WorkflowIndicatorCellComponent,
    ProductGroupDetailComponent,
    MeasureCellComponent,
    StringListFilterComponent,
    ApproveHeaderComponent
  ],
  exports: [
    ApproveCellComponent,
    DateCellComponent,
    DateFilterComponent,
    NumberFilterComponent,
    NumberCellComponent,
    NumberCellEditComponent,
    SetFilterComponent,
    StatusCellComponent,
    StringFilterComponent,
    SimpleHeaderComponent,
    FreezeTabComponent,
    ShowHideTabComponent,
    StandardHeaderComponent,
    PriceLadderCellComponent,
    PriceLadderCellEditComponent,
    PercentageCellComponent,
    CurrencyCellComponent,
    CreateScenarioRendererComponent,
    EmptyHeaderComponent,
    WorkflowIndicatorCellComponent,
    ProductGroupDetailComponent,
    MeasureCellComponent,
    StringListFilterComponent,
    ApproveHeaderComponent
  ],
  providers: [
    ServerParamsUtils,
    GridUtils,
  ]
})

export class GridModule {}
