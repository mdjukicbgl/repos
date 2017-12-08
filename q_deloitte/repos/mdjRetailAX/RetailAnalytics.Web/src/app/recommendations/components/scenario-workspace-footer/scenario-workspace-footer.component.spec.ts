import { ReviseService } from '../../services/revise.service';
import { RecommendationsModel } from '../../models/recommendations.model';
import { NgbBootstrapModule } from '../../../shared/ngbBootstrap/ngbBootstrap.module';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ScenarioWorkspaceFooterComponent } from './scenario-workspace-footer.component';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { Observable } from 'rxjs/Observable';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';
import { LocalizationModule } from 'angular-l10n';

class MockReviseService {
  revise() {}
}

class MockRecommendationsModel {
  acceptRecommendation() {}
  rejectRecommendation() {}
}

describe('ScenarioWorkspaceFooterComponent', () => {
  let component: ScenarioWorkspaceFooterComponent;
  let fixture: ComponentFixture<ScenarioWorkspaceFooterComponent>;
  let model, reviseService;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ScenarioWorkspaceFooterComponent ],
      imports: [
        NgbBootstrapModule,
        LocalizationModule.forRoot(),
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
      ]
    })
    .overrideComponent(ScenarioWorkspaceFooterComponent, {
    set: {
      providers: [
        { provide: RecommendationsModel, useClass: MockRecommendationsModel },
        { provide: ReviseService, useClass: MockReviseService }
      ],
    }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioWorkspaceFooterComponent);
    component = fixture.componentInstance;
    component.selectedRecommendations = [{
      data: {
        scenarioId: 1,
        recommendationGuid: 'guid1'
      }
    }] as any;
    model = fixture.debugElement.injector.get(RecommendationsModel);
    reviseService = fixture.debugElement.injector.get(ReviseService);
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should call accept when clicked', () => {
    spyOn(model, 'acceptRecommendation');
    component.onAcceptClicked();
    expect(model.acceptRecommendation).toHaveBeenCalledWith(1, 'guid1');
  });

  it('should call reject when clicked', () => {
    spyOn(model, 'rejectRecommendation');
    component.onRejectClicked();
    expect(model.rejectRecommendation).toHaveBeenCalledWith(1, 'guid1');
  });

  it('should call revise when clicked', () => {
    spyOn(reviseService, 'revise');
    component.onUpdateClicked();
    expect(reviseService.revise).toHaveBeenCalled();
  });

});
