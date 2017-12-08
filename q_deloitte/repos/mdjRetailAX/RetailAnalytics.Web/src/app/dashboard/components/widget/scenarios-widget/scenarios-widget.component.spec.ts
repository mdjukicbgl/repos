import { Scenario } from '../../../../scenarios/models/scenarios.entity';
import { StoreModule } from '@ngrx/store';
import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { Router } from '@angular/router';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { BrowserDynamicTestingModule } from '@angular/platform-browser-dynamic/testing';
import { DashboardModel } from '../../../../dashboard/models/dashboard.model';
import { ScenariosWidgetComponent } from './scenarios-widget.component';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { NgSpinKitModule } from 'ng-spin-kit';
import { Observable } from 'rxjs/Observable';
import { StoreMgmtService } from 'app/shared/store-mgmt/store-mgmt.service';

// Router Mock
let router = {
  navigate: jasmine.createSpy('navigate')
};

// Sample Data
let d = new Date();
let scenarios: Scenario[] = [{
  scenarioId: 1,
  week: 1,
  scheduleWeekMin: 1,
  scheduleWeekMax: 1,
  scheduleStageMin: 1,
  scheduleStageMax: 1,
  stageMax: 1,
  stageOffsetMax: 1,
  priceFloor: 1,
  clientId: 1,
  scenarioName: 'test',
  scheduleMask: 1,
  lastRunDate: undefined,
  status: 'Running',
  productCount: 1,
  recommendationCount: 1,
  duration: 1,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 1,
  partitionSuccessCount: 1,
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
  scenarioId: 1,
  week: 1,
  scheduleWeekMin: 1,
  scheduleWeekMax: 1,
  scheduleStageMin: 1,
  scheduleStageMax: 1,
  stageMax: 1,
  stageOffsetMax: 1,
  priceFloor: 1,
  clientId: 1,
  scenarioName: 'test',
  scheduleMask: 1,
  lastRunDate: new Date(d.setDate(d.getDate() - 1)),
  status: 'Complete',
  productCount: 1,
  recommendationCount: 1,
  duration: 1,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 1,
  partitionSuccessCount: 1,
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
  scenarioId: 1,
  week: 1,
  scheduleWeekMin: 1,
  scheduleWeekMax: 1,
  scheduleStageMin: 1,
  scheduleStageMax: 1,
  stageMax: 1,
  stageOffsetMax: 1,
  priceFloor: 1,
  clientId: 1,
  scenarioName: 'test',
  scheduleMask: 1,
  lastRunDate: new Date(d.setDate(d.getDate() - 7)),
  status: 'Complete',
  productCount: 1,
  recommendationCount: 1,
  duration: 1,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 1,
  partitionSuccessCount: 1,
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
  scenarioId: 1,
  week: 1,
  scheduleWeekMin: 1,
  scheduleWeekMax: 1,
  scheduleStageMin: 1,
  scheduleStageMax: 1,
  stageMax: 1,
  stageOffsetMax: 1,
  priceFloor: 1,
  clientId: 1,
  scenarioName: 'test',
  scheduleMask: 1,
  lastRunDate: new Date(d.setDate(d.getDate() - 10)), // Not within a week
  status: 'Complete',
  productCount: 1,
  recommendationCount: 1,
  duration: 1,
  partitionTotal: 1,
  partitionCount: 1,
  partitionErrorCount: 1,
  partitionSuccessCount: 1,
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

// Dashboard Model Mock
class MockDashboardModel {
  scenarios$: Observable<Scenario[]> = Observable.of(scenarios);
  isLoadingScenarios$: Observable<Boolean> = Observable.of(false);
  hasLoadingScenariosFailed$: Observable<Boolean> = Observable.of(false);
  loadScenarios = jasmine.createSpy('loadScenarios');
}

// Test Setup
describe('ScenarioWidgetComponent', () => {
  let component: ScenariosWidgetComponent;
  let fixture: ComponentFixture<ScenariosWidgetComponent>;
  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ScenariosWidgetComponent],
      imports: [
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        CommonModule,
        NgSpinKitModule,
      ],
    })
    .overrideModule(BrowserDynamicTestingModule, {
      set: {
        entryComponents: [ScenariosWidgetComponent]
      }
    })
    .overrideComponent(ScenariosWidgetComponent, {
      set: {
        providers: [
          { provide: DashboardModel, useClass: MockDashboardModel },
          { provide: Router, useValue: router }
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenariosWidgetComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should group scenarios', () => {
    let groupedScenarios = component.groupScenariosByStatus(scenarios);
    expect(groupedScenarios.length).toBe(2);
    expect(groupedScenarios[0].status).toBe('Running');
    expect(groupedScenarios[0].scenarios.length).toBe(1);
    expect(groupedScenarios[1].status).toBe('Complete');
    expect(groupedScenarios[1].scenarios.length).toBe(3);
  });

  it('should calculate scenarios ran per week', () => {
    let scenariosCompleted = component.calculateScenariosPerWeek(scenarios);
    expect(scenariosCompleted).toBe(1);
  });

  it('should allow the user to navigate to the scenarios screen', () => {
    component.navigateToScenarios('Running');
    expect(router.navigate).toHaveBeenCalledWith(['/markdown/scenarios', Object({ status: 'Running' })]);
    component.navigateToScenarios('Complete');
    expect(router.navigate).toHaveBeenCalledWith(['/markdown/scenarios', Object({ status: 'Complete' })]);
  });

});
