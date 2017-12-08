import { PriceLadder } from './../../models/recommendations.entity';
import { ScenarioWorkspaceTotalsComponent } from '../scenario-workspace-totals/scenario-workspace-totals.component';
import { ScenarioWorkspaceFooterComponent } from '../scenario-workspace-footer/scenario-workspace-footer.component';
import { LocaleUtil } from '../../../shared/utils/locale-util/locale-util';
import { AlertsModule } from '../../../shared/alerts/alerts.module';
import { WorkspacePreferencesService } from '../../services/workspace-preferences.service';
import {
    ScenarioWorkspaceNotificationsComponent
} from '../scenario-workspace-notifications/scenario-workspace-notifications.component';
import { GridUtils } from '../../../shared/grid/utils/grid-utils';
import { Store, provideStore } from '@ngrx/store';
import { AuthModule, authHttpServiceFactory } from '../../../shared/auth/auth.module';
import { AuthHttp, AuthConfig } from 'angular2-jwt';
import { GridModule } from '../../../shared/grid/grid.module';
import { GridModel } from '../../../shared/grid/models/grid.model';
import { Http, RequestOptions } from '@angular/http';
import { NgbBootstrapModule } from '../../../shared/ngbBootstrap/ngbBootstrap.module';
import { Injectable } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';
import { ServerParams } from '../../../shared/grid/models/server-params.entity';
import { ScenariosModel } from '../../../scenarios/models/scenarios.model';
import { RecommendationsModel } from '../../models/recommendations.model';
import { NgModule, NO_ERRORS_SCHEMA } from '@angular/core';
import { GridRecommendations, ScenarioProductRecommendation } from '../../models/recommendations.entity';
import { BehaviorSubject, Observable, Subject } from 'rxjs/Rx';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { ScenarioWorkspaceComponent } from './scenario-workspace.component';
import { NavigationModule } from '../../../shared/navigation/navigation.module';
import { AgGridModule } from 'ag-grid-angular/main';
import { CommonModule } from '@angular/common';
import { NgbModal, NgbModalModule, NgbTabsetModule } from '@ng-bootstrap/ng-bootstrap';
import { WindowSize } from '../../../shared/utils/window-size/window-size';
import { FormsModule }   from '@angular/forms';
import { LicenseManager } from 'ag-grid-enterprise/main';
import { NgSpinKitModule } from 'ng-spin-kit';
LicenseManager.setLicenseKey
('ag-Grid_Evaluation_License_Not_for_Production_100Devs26_July_2017__MTUwMTAyMzYwMDAwMA==d8b073e5adc2a2e1debe4e10d508e42c');
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { LocalizationModule } from 'angular-l10n';
import { HttpModule } from '@angular/http';
import { StoreMgmtService } from '../../../shared/store-mgmt/store-mgmt.service';

import {
  ApproveCellComponent,
  StringFilterComponent,
  NumberFilterComponent,
  NumberCellComponent,
  SetFilterComponent,
  SimpleHeaderComponent,
  StandardHeaderComponent,
  PriceLadderCellComponent,
  PriceLadderCellEditComponent,
  PercentageCellComponent,
  CurrencyCellComponent,
  EmptyHeaderComponent,
  ApproveHeaderComponent,
  StringListFilterComponent } from '../../../shared/grid';


@Injectable()
export class ActivatedRouteStub {
    private subject = new BehaviorSubject(this.testParams);
    params = this.subject.asObservable();
    private _testParams: {};
    get testParams() { return this._testParams; }
    set testParams(params: {}) {
        this._testParams = params;
        this.subject.next(params);
    }
    get snapshot() {
        return { params: this.testParams };
    }
    get parent() {
        return { params: this.subject.asObservable() };
    }
}

let recommendations: any[] = [
  {'scenarioId': 5, 'recommendationGuid': '62b9d316-1e96-28ca-e225-f5640a2da567', 'hierarchyName': 'MATTRESS PROTECTORS',
  'productId': 10441, 'productName': 'R+R VINYL DEEP FIT MATTRESS COVER F', 'originalSellingPrice': 10.23,
  'currentSellingPrice': 9.91, 'sellThroughTarget': 580, 'terminalStock': 0, 'totalRevenue': 3905155.9061,
  'projections': [{'price': 9.91, 'discount': 0, 'quantity': 0}, {'price': 9.91, 'discount': 0, 'quantity': 0},
  {'price': 9.91, 'discount': 0, 'quantity': 0}, {'price': 9.91, 'discount': 0, 'quantity': 0}], 'status': 'REJECTED',
  'markdownCost': 0, 'price1': 9.91, 'discount1': 0, 'price2': 9.91, 'discount2': 0, 'price3': 9.91, 'discount3': 0, 'price4': 9.91,
  'discount4': 0},

  {'scenarioId': 5, 'recommendationGuid': '6d946889-312d-f235-cd3b-aadf2d586dd1', 'hierarchyName': 'MATTRESS PROTECTORS',
  'productId': 21589, 'productName': 'R+R VINYL DEEP FIT MATTRESS COVER T', 'originalSellingPrice': 8.06,
  'currentSellingPrice': 7.93, 'sellThroughTarget': 875, 'terminalStock': 0, 'totalRevenue': 5393892.1244,
  'projections': [{'price': 7.93, 'discount': 0, 'quantity': 0}, {'price': 0.806, 'discount': 0.1, 'quantity': 0},
  {'price': 0.806, 'discount': 0.1, 'quantity': 0}, {'price': 6.851, 'discount': 0.85, 'quantity': 0}],
  'status': 'ACCEPTED', 'markdownCost': 0, 'price1': 7.93, 'discount1': 0, 'price2': 0.806, 'discount2': 0.1, 'price3': 0.806,
  'discount3': 0.1, 'price4': 6.851, 'discount4': 0.85}
];

let updatedRecommendations: ScenarioProductRecommendation[] = [{
  recommendationGuid: 'string',
  scenarioId: 123,
  hierarchyName: 'string',
  productId: 123,
  productName: 'string',
  originalSellingPrice: 123,
  currentSellingPrice: 123,
  sellThroughTarget: 123,
  terminalStock: 123,
  totalRevenue: 123,
  status: 123,
  projections: null,
  markdownCost: 123,
  priceLadderId: 1,
  revisionId: 1,
  currentMarkdownDepth: 1,
  currentDiscountLadderDepth: 1,
}]

let node: any = {
  setData: () => {}
};

class MockRecommendationsModel {

  recommendationsSource = new BehaviorSubject<GridRecommendations>(
    { items: recommendations, projectionCount: 0, priceLadderId: 0, scheduleMask: ''} );
  recommendations$: Observable<GridRecommendations> = this.recommendationsSource.asObservable();

  recommendationsFiltersSource = new BehaviorSubject<ServerParams>({filters: [], sorts: [], paging: null});
  recommendationsFilters$: Observable<ServerParams> = this.recommendationsFiltersSource.asObservable();

  updatedRecommendationsSource = new BehaviorSubject<ScenarioProductRecommendation[]>(updatedRecommendations);
  updatedRecommendations$: Observable<ScenarioProductRecommendation[]> = this.updatedRecommendationsSource.asObservable();

  reviseHasFailedSource = new BehaviorSubject<Boolean>(true);
  reviseHasFailed$: Observable<Boolean> = this.reviseHasFailedSource.asObservable();

  acceptAllRecommendationsHasFailedSource = new BehaviorSubject<Boolean>(true);
  acceptAllRecommendationsHasFailed$: Observable<Boolean> = this.acceptAllRecommendationsHasFailedSource.asObservable();

  rejectAllRecommendationsHasFailedSource = new BehaviorSubject<Boolean>(true);
  rejectAllRecommendationsHasFailed$: Observable<Boolean> = this.rejectAllRecommendationsHasFailedSource.asObservable();

  priceLadderSource = new BehaviorSubject<PriceLadder>({
    priceLadderId: 1,
    priceLadderTypeId: 1,
    description: 'desc',
    values: [5, 10, 15, 20]
  });
  priceLadder$: Observable<PriceLadder> = this.priceLadderSource.asObservable();

  acceptAllRecommendationsCompleteSource = new BehaviorSubject<Boolean>(true);
  acceptAllRecommendationsComplete$: Observable<Boolean> = this.acceptAllRecommendationsCompleteSource.asObservable();

  rejectAllRecommendationsCompleteSource = new BehaviorSubject<Boolean>(true);
  rejectAllRecommendationsComplete$: Observable<Boolean> = this.rejectAllRecommendationsCompleteSource.asObservable();

  loadRecommendationsFiltered = () => {
    this.recommendationsSource.next({ items: recommendations, projectionCount: 0, priceLadderId: 0, scheduleMask: ''});
  }

  setRecommendationsFilter = function(){
    this.recommendationsFiltersSource.next({filters: [], sorts: [], paging: null});
  };

  loadScenarioTotals = () => {};

  loadPriceLadder = () => {};
}

class MockScenariosModel {
  loadSelectedScenario = () => {};
}

class MockWorkspacePreferencesService {
  setLastScenarioId = () => {};
  setScenarioGridState = () => {};
  setWorkspaceSortState = () => {};
  setWorkspaceGridState = () => {};
  getScenarioSortModel = () => { };
};

let component: ScenarioWorkspaceComponent;
let fixture: ComponentFixture<ScenarioWorkspaceComponent>;
let nativeElement: HTMLElement | null;
let model, scenariosModel, activatedRoute;

describe('ScenarioWorkspaceComponent', () => {
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ScenarioWorkspaceComponent, ScenarioWorkspaceTotalsComponent ],
      imports: [
        HttpModule,
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        RouterTestingModule,

        AgGridModule.withComponents([
          ApproveCellComponent,
          StringFilterComponent,
          NumberFilterComponent,
          NumberCellComponent,
          SetFilterComponent,
          SimpleHeaderComponent,
          StandardHeaderComponent,
          PriceLadderCellComponent,
          PriceLadderCellEditComponent,
          PercentageCellComponent,
          CurrencyCellComponent,
          EmptyHeaderComponent,
          ApproveHeaderComponent]),

        NavigationModule,
        NgbBootstrapModule,
        GridModule,
        FormsModule,
        NgSpinKitModule,
        AlertsModule
      ],
      schemas: [ NO_ERRORS_SCHEMA ],
      providers: [ WindowSize, GridUtils, LocaleUtil, provideStore({}), {
        provide: AuthHttp,
        useFactory: authHttpServiceFactory,
        deps: [Http, RequestOptions]
    }, StoreMgmtService ]
    })
    .overrideComponent(ScenarioWorkspaceComponent, {
      set: {
        providers: [
          { provide: RecommendationsModel, useClass: MockRecommendationsModel },
          { provide: ScenariosModel, useClass: MockScenariosModel },
          { provide: ActivatedRoute, useClass: ActivatedRouteStub },
          { provide: WorkspacePreferencesService, useClass: MockWorkspacePreferencesService }
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioWorkspaceComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    model = fixture.debugElement.injector.get(RecommendationsModel);
    scenariosModel = fixture.debugElement.injector.get(ScenariosModel);
    activatedRoute = fixture.debugElement.injector.get(ActivatedRoute);
    activatedRoute.testParams = { scenarioId: 12345};
    model.recommendationsSource.next({items: recommendations, projectionCount: 0});
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should set scenario based on url', () => {
    expect(component.hasNoSelectedScenario).toEqual(false);
  });

  it('should reload selected scenario when refreshing the data', () => {
    spyOn(component.totalsComponent, 'loadSelectedScenario');
    component.refreshRecommendations();
    expect(component.totalsComponent.loadSelectedScenario).toHaveBeenCalled();
  });

});

describe('ScenarioWorkspaceComponent', () => {
  beforeEach(async(() => {
    localStorage.removeItem('lastScenarioId');
    TestBed.configureTestingModule({
      declarations: [ ScenarioWorkspaceComponent ],
      imports: [
        HttpModule,
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        RouterTestingModule,
        GridModule,
        AgGridModule.withComponents([
          ApproveCellComponent,
          StringFilterComponent,
          NumberFilterComponent,
          NumberCellComponent,
          SetFilterComponent,
          SimpleHeaderComponent,
          StandardHeaderComponent,
          PriceLadderCellComponent,
          PriceLadderCellEditComponent,
          PercentageCellComponent,
          CurrencyCellComponent,
          EmptyHeaderComponent,
          ApproveHeaderComponent
        ]),
        NavigationModule,
        NgSpinKitModule ],
      providers: [ WindowSize, GridUtils, LocaleUtil, provideStore({}), {
        provide: AuthHttp,
        useFactory: authHttpServiceFactory,
        deps: [Http, RequestOptions]
    }, ],
      schemas: [ NO_ERRORS_SCHEMA ],
    })
    .overrideComponent(ScenarioWorkspaceComponent, {
      set: {
        providers: [
          { provide: RecommendationsModel, useClass: MockRecommendationsModel },
          { provide: ScenariosModel, useClass: MockScenariosModel },
          { provide: WorkspacePreferencesService, useClass: MockWorkspacePreferencesService }
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioWorkspaceComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    scenariosModel = fixture.debugElement.injector.get(ScenariosModel);
    model = fixture.debugElement.injector.get(RecommendationsModel);
    fixture.detectChanges();
  });

  it('should set show error if no scenario', () => {
    expect(component.hasNoSelectedScenario).toEqual(true);
  });

});






