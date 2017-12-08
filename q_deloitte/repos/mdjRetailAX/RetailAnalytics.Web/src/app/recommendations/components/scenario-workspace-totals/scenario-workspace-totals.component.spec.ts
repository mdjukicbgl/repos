import { LocaleUtil } from '../../../shared/utils/locale-util/locale-util';
import { NgbBootstrapModule } from '../../../shared/ngbBootstrap/ngbBootstrap.module';
import { LocalizationModule } from 'angular-l10n';
import { ScenariosModel } from '../../../scenarios/models/scenarios.model';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { ScenarioWorkspaceTotalsComponent } from './scenario-workspace-totals.component';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

class MockRecommendationsModel {
  loadScenarioTotals = () => {};
}

class MockScenariosModel {
  loadSelectedScenario = () => {};
}

describe('ScenarioWorkspaceTotalsComponent', () => {
  let component: ScenarioWorkspaceTotalsComponent;
  let fixture: ComponentFixture<ScenarioWorkspaceTotalsComponent>;
  let nativeElement: any;
  let scenariosModel: any;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      imports: [
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
        NgbBootstrapModule
      ],
      declarations: [ ScenarioWorkspaceTotalsComponent ],
      providers: [ LocaleUtil ]
    })
    .overrideComponent(ScenarioWorkspaceTotalsComponent, {
      set: {
        providers: [
          { provide: ScenariosModel, useClass: MockScenariosModel },
        ],
      }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioWorkspaceTotalsComponent);
    component = fixture.componentInstance;
    nativeElement = fixture.nativeElement;
    scenariosModel = fixture.debugElement.injector.get(ScenariosModel);
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should load a selected scenario when asked', () => {
    component.selectedScenarioId = 321;
    spyOn(scenariosModel, 'loadSelectedScenario');
    component.loadSelectedScenario();
    expect(scenariosModel.loadSelectedScenario).toHaveBeenCalledWith(321);
  });

});
