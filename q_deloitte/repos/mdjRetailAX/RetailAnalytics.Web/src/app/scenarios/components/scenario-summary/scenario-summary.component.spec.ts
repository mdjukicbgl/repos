import { LocaleUtil } from '../../../shared/utils/locale-util/locale-util';
import { AlertsModule } from '../../../shared/alerts/alerts.module';
import { GridUtils } from '../../../shared/grid/utils/grid-utils';
import { Store, provideStore } from '@ngrx/store';
import { AuthModule, authHttpServiceFactory } from '../../../shared/auth/auth.module';
import { AuthHttp, AuthConfig } from 'angular2-jwt';
import { GridModule } from '../../../shared/grid/grid.module';
import { GridModel } from '../../../shared/grid/models/grid.model';
import { Http, RequestOptions } from '@angular/http';
import { NgbBootstrapModule } from '../../../shared/ngbBootstrap/ngbBootstrap.module';
import { FormsModule } from '@angular/forms';
import { NgModule, NO_ERRORS_SCHEMA } from '@angular/core';
import { NgbDatepickerModule, NgbTabsetModule } from '@ng-bootstrap/ng-bootstrap';
import { NavigationModule } from '../../../shared/navigation/navigation.module';
import { ServerParams } from '../../../shared/grid/models/server-params.entity';
import { WindowSize } from '../../../shared/utils/window-size/window-size';
import { ScenariosModel } from '../../models/scenarios.model';
import { Scenario } from '../../models/scenarios.entity';
import { ScenarioSummaryComponent } from './scenario-summary.component';
import { Injectable } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRoute } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { AgGridModule } from 'ag-grid-angular/main';
import { LicenseManager } from 'ag-grid-enterprise/main';
import { BehaviorSubject, Observable } from 'rxjs/Rx';
import { NgbModalModule } from '@ng-bootstrap/ng-bootstrap/modal/modal.module';
import { ActivatedRouteStub } from '../../../shared/test-helpers/activated-route';
LicenseManager.setLicenseKey
('ag-Grid_Evaluation_License_Not_for_Production_100Devs26_July_2017__MTUwMTAyMzYwMDAwMA==d8b073e5adc2a2e1debe4e10d508e42c');
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { LocalizationModule } from 'angular-l10n';
import { HttpModule } from '@angular/http';
import { UserPreferencesService } from '../../../shared/user-preferences/services/user-preferences.service';

import {
  StatusCellComponent,
  DateCellComponent,
  ApproveCellComponent,
  StringFilterComponent,
  NumberFilterComponent,
  NumberCellEditComponent,
  SetFilterComponent,
  NumberCellComponent,
  StandardHeaderComponent,
  DateFilterComponent,
  FreezeTabComponent,
  ShowHideTabComponent,
  EmptyHeaderComponent,
  SimpleHeaderComponent
} from '../../../shared/grid';

// Sample Data
let d = new Date();
let scenarios: Scenario[] = [
{
  scenarioId: 100,
  duration: 26.070102,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 0,
  partitionSuccessCount: 0,
  status: 'Running',
  lastRunDate: undefined,
  productCount: 349,
  recommendationCount: 5105172,
  clientId: 0,
  scenarioName: 'Default scenario',
  week: 890,
  scheduleMask: 255,
  scheduleWeekMin: 891,
  scheduleWeekMax: 899,
  scheduleStageMin: 1,
  scheduleStageMax: 4,
  stageMax: null,
  stageOffsetMax: null,
  priceFloor: null,
  productsCost: 1,
  productsAcceptedCost: 1,
  productsAcceptedCount: 1,
  productsRejectedCount: 1,
  //Todo: Remove
  statusNew:true,
  statusPublished:true,
  statusAccepted:true,
  statusRejected:true,
  productGroupSummary: null
},
{
  scenarioId: 100,
  duration: 26.070102,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 0,
  partitionSuccessCount: 0,
  status: 'Complete',
  lastRunDate: new Date(d.setDate(d.getDate())),
  productCount: 349,
  recommendationCount: 5105172,
  clientId: 0,
  scenarioName: 'Default scenario 2',
  week: 890,
  scheduleMask: 255,
  scheduleWeekMin: 891,
  scheduleWeekMax: 899,
  scheduleStageMin: 1,
  scheduleStageMax: 4,
  stageMax: null,
  stageOffsetMax: null,
  priceFloor: null,
  productsCost: 1,
  productsAcceptedCost: 1,
  productsAcceptedCount: 1,
  productsRejectedCount: 1,
  //Todo: Remove
  statusNew:true,
  statusPublished:true,
  statusAccepted:true,
  statusRejected:true,
  productGroupSummary: null
},
{
  scenarioId: 100,
  duration: 26.070102,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 0,
  partitionSuccessCount: 0,
  status: 'Complete',
  lastRunDate: new Date(d.setDate(d.getDate() - 7)),
  productCount: 349,
  recommendationCount: 5105172,
  clientId: 0,
  scenarioName: 'Default scenario 3',
  week: 890,
  scheduleMask: 255,
  scheduleWeekMin: 891,
  scheduleWeekMax: 899,
  scheduleStageMin: 1,
  scheduleStageMax: 4,
  stageMax: null,
  stageOffsetMax: null,
  priceFloor: null,
  productsCost: 1,
  productsAcceptedCost: 1,
  productsAcceptedCount: 1,
  productsRejectedCount: 1,
  //Todo: Remove
  statusNew:true,
  statusPublished:true,
  statusAccepted:true,
  statusRejected:true,
  productGroupSummary: null
},
{
  scenarioId: 100,
  duration: 26.070102,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 0,
  partitionSuccessCount: 0,
  status: 'Complete',
  lastRunDate: new Date(d.setDate(d.getDate() - 8)),
  productCount: 349,
  recommendationCount: 5105172,
  clientId: 0,
  scenarioName: 'Default scenario 4',
  week: 890,
  scheduleMask: 255,
  scheduleWeekMin: 891,
  scheduleWeekMax: 899,
  scheduleStageMin: 1,
  scheduleStageMax: 4,
  stageMax: null,
  stageOffsetMax: null,
  priceFloor: null,
  productsCost: 1,
  productsAcceptedCost: 1,
  productsAcceptedCount: 1,
  productsRejectedCount: 1,
  //Todo: Remove
  statusNew:true,
  statusPublished:true,
  statusAccepted:true,
  statusRejected:true,
  productGroupSummary: null
}];

// Scenarios Model Mock
class MockScenariosModel {

  scenariosInitialScource = new BehaviorSubject<Scenario[]>(scenarios);
  scenariosInitial$: Observable<Scenario[]> = this.scenariosInitialScource.asObservable();

  scenariosScource = new BehaviorSubject<Scenario[]>(scenarios);
  scenarios$: Observable<Scenario[]> = this.scenariosScource.asObservable();

  scenariosFiltersSource = new BehaviorSubject<ServerParams>({filters: [], sorts: [], paging: null});
  scenariosFilters$: Observable<ServerParams> = this.scenariosFiltersSource.asObservable();

  isLoadingScenarios$: Observable<Boolean> = Observable.of(false);
  hasLoadingScenariosFailed$: Observable<Boolean> = Observable.of(false);

  loadScenariosInitial = () => {};
  loadScenarios = () => {
    this.scenariosScource.next(scenarios);
  }
  loadScenariosFiltered = () => {};

  setScenariosFilter = (filters) => {
    this.scenariosFiltersSource.next(filters);
  }
}

class MockUserPreferencesService {
  setLastWorkspace = () => {};
  debounceSetScenarioGridState = () => {};
  setState = () => {};
};

let component: ScenarioSummaryComponent;
let fixture: ComponentFixture<ScenarioSummaryComponent>;
let nativeElement: HTMLElement | null;
let model, activatedRoute;

describe('ScenarioSummaryComponent', () => {
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ScenarioSummaryComponent ],
      imports: [
        HttpModule,
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        RouterTestingModule,
        LocalizationModule.forRoot(),
        AgGridModule.withComponents([
          StatusCellComponent,
          DateCellComponent,
          ApproveCellComponent,
          StringFilterComponent,
          NumberFilterComponent,
          SetFilterComponent,
          DateFilterComponent,
          NumberCellComponent,
          StandardHeaderComponent,
          EmptyHeaderComponent,
          SimpleHeaderComponent,
          AuthModule]),
        NavigationModule,
        NgbBootstrapModule,
        GridModule,
        FormsModule,
        AlertsModule],
      providers: [ WindowSize, GridUtils, LocaleUtil, provideStore({}),{
        provide: AuthHttp,
        useFactory: authHttpServiceFactory,
        deps: [Http, RequestOptions]
    }, ],
      schemas: [ NO_ERRORS_SCHEMA ],
    })
    .overrideComponent(ScenarioSummaryComponent, {
      set: {
        providers: [
          { provide: ScenariosModel, useClass: MockScenariosModel },
          { provide: ActivatedRoute, useClass: ActivatedRouteStub },
          { provide: UserPreferencesService, useClass: MockUserPreferencesService }
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioSummaryComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    model = fixture.debugElement.injector.get(ScenariosModel);
    activatedRoute = fixture.debugElement.injector.get(ActivatedRoute);
    activatedRoute.testParams = { status: 'New'};
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

});
