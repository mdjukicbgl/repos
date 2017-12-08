import { AlertsModule } from '../../../shared/alerts/alerts.module';
import { NO_ERRORS_SCHEMA } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs/Rx';
import { Router, ActivatedRoute } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { NavigationModule } from '../../../shared/navigation/navigation.module';
import { RouterTestingModule } from '@angular/router/testing';
import { TreeModule, SliderModule, TreeNode } from 'primeng/primeng';
import { ScenariosModel } from '../../models/scenarios.model';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ActivatedRouteStub } from '../../../shared/test-helpers/activated-route';
import { ScenarioEditComponent } from './scenario-edit.component';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { NgbBootstrapModule } from '../../../shared/ngbBootstrap/ngbBootstrap.module';
import { LocalizationModule } from 'angular-l10n';

let productHierarchy: any = {};
let treeNodes: any = [{hierarchyId: 7794, parentId: 7793, path: ':7793:7794:', name: 'Unknown', depth: 1}];

// Scenarios Model Mock
class MockScenariosModel {

  loadScenarioProductHierarchyRoot() {};
  loadScenarioProductHierarchyChildren() {};
  saveScenario() {};
  resetScenarioRunHasFailed() {};
  resetScenarioSaveHasFailed() {};

  // Sources
  scenarioRunCompleteSource = new BehaviorSubject<Boolean>(false);
  newScenarioIdSource = new BehaviorSubject<Boolean>(false);
  scenarioSaveCompleteSource = new BehaviorSubject<Boolean>(false);

  // Observables
  scenarioRunComplete$: Observable<Boolean> = this.scenarioRunCompleteSource.asObservable();
  newScenarioId$: Observable<Boolean> = this.newScenarioIdSource.asObservable();
  scenarioSaveComplete$: Observable<Boolean> = this.scenarioSaveCompleteSource.asObservable();
}

let component: ScenarioEditComponent;
let fixture: ComponentFixture<ScenarioEditComponent>;
let nativeElement: HTMLElement | null;
let model;

describe('ScenarioEditComponent', () => {
  let component: ScenarioEditComponent;
  let fixture: ComponentFixture<ScenarioEditComponent>;

  beforeEach(async(() => {

    TestBed.configureTestingModule({
      declarations: [ ScenarioEditComponent ],
      imports: [
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        NavigationModule,
        FormsModule,
        TreeModule,
        RouterTestingModule,
        AlertsModule,
        NgbBootstrapModule
      ],
      schemas: [ NO_ERRORS_SCHEMA ]
    })
    .overrideComponent(ScenarioEditComponent, {
      set: {
        providers: [
          { provide: ScenariosModel, useClass: MockScenariosModel },
          { provide: ActivatedRoute, useClass: ActivatedRouteStub }
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioEditComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    model = fixture.debugElement.injector.get(ScenariosModel);
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should perform validation on save', () => {
    let navigateSpy = spyOn((<any>component).router, 'navigate');
    component.saveScenario(false);
    expect(component.errors.length).toEqual(3);
    component.scenarioName = 'test';
    component.saveScenario(false);
    expect(component.errors.length).toEqual(2);
    component.selectedWeeks = '10101010';
    component.saveScenario(false);
    expect(component.errors.length).toEqual(1);
    component.selectedProducts = '123, 321, 456';
    component.saveScenario(false);
    expect(component.errors.length).toEqual(0);
    component.selectedProducts = undefined;
    component.uploadedFileGuid = 'abc';
    component.saveScenario(false);
    expect(component.errors.length).toEqual(0);
  });

  it('should reset validation', () => {
    component.saveScenario(false);
    expect(component.errors.length).toEqual(3);
    component.resetErrors();
    expect(component.errors.length).toEqual(0);
  });

  it('should set the selected weeks', () => {
    component.setSelectedWeeks('1010101');
    expect(component.selectedWeeks).toEqual('1010101');
  });

  it('should set the uploaded file guid', () => {
    component.setUploadedFileGuid('abc');
    expect(component.uploadedFileGuid).toEqual('&uploadedFile=abc');
  });

  it('should show a modal when a user clicks save and run', () => {
    component.scenarioName = 'test';
    component.selectedWeeks = '10101010';
    component.selectedProducts = '123, 321, 456';
    let modalSpy = spyOn(component, 'openModalService');
    expect(modalSpy).not.toHaveBeenCalled();
    component.saveScenario(true);
    expect(modalSpy).toHaveBeenCalled();
  });

  it('should save and run a scenario when a user clicks confirm', () => {
    component.scenarioName = 'test';
    component.selectedWeeks = '101010101';
    component.selectedProducts = '123, 456, 789';
    component.uploadedFileGuid = 'guid';

    let saveScenarioSpy = spyOn(model, 'saveScenario');
    let runScenarioSpy = spyOn(component, 'runScenario');
    component.modalConfirmButtonClicked(() => {});
    expect(saveScenarioSpy).toHaveBeenCalledWith('test', '101010101', '', 'guid');
    model.scenarioSaveCompleteSource.next(true);
    model.newScenarioIdSource.next(123);
    expect(runScenarioSpy).toHaveBeenCalledWith(123);
  });

  it('should navigate to list upon run completion', () => {
    component.scenarioName = 'test';
    component.selectedWeeks = '101010101';
    component.selectedProducts = '123, 456, 789';
    let navigateSpy = spyOn((<any>component).router, 'navigate');
    component.modalConfirmButtonClicked(() => {});
    model.scenarioRunCompleteSource.next(true);
    expect(navigateSpy).toHaveBeenCalledWith(['/markdown/scenarios']);
  });

  it('should save but not run a scenario when a user clicks cancel', () => {
    component.scenarioName = 'test';
    component.selectedWeeks = '101010101';
    component.selectedProducts = '123, 456, 789';
    let navigateSpy = spyOn((<any>component).router, 'navigate');
    let saveScenarioSpy = spyOn(model, 'saveScenario');
    let runScenarioSpy = spyOn(component, 'runScenario');
    component.modalCancelButtonClicked(() => {});
    expect(saveScenarioSpy).toHaveBeenCalledWith('test', '101010101', '', '');
    model.scenarioSaveCompleteSource.next(true);
    model.newScenarioIdSource.next(123);
    expect(runScenarioSpy).not.toHaveBeenCalledWith();
  });

  it('should navigate to list upon save completion', () => {
    component.scenarioName = 'test';
    component.selectedWeeks = '101010101';
    component.selectedProducts = '123, 456, 789';
    let navigateSpy = spyOn((<any>component).router, 'navigate');
    component.modalCancelButtonClicked(() => {});
    model.scenarioSaveCompleteSource.next(true);
    expect(navigateSpy).toHaveBeenCalledWith(['/markdown/scenarios']);
  });

});
