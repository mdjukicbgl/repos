import { RecommendationsModel } from '../../models/recommendations.model';

import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ScenarioWorkspaceNotificationsComponent } from './scenario-workspace-notifications.component';
import { Observable } from 'rxjs/Observable';
import { NgSpinKitModule } from 'ng-spin-kit';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { TranslateModule, TranslateService, TranslateLoader, TranslateFakeLoader } from '@ngx-translate/core';

class MockRecommendationsModel {

    //Sources
    recommendationsHasFailedSource = new BehaviorSubject<Boolean>(false);

    acceptRecommendationHasFailedSource = new BehaviorSubject<Boolean>(false);
    rejectRecommendationHasFailedSource = new BehaviorSubject<Boolean>(false);

    acceptAllRecommendationsCompleteSource = new BehaviorSubject<Boolean>(false);
    acceptAllRecommendationsIsLoadingSource = new BehaviorSubject<Boolean>(false);
    acceptAllRecommendationsHasFailedSource = new BehaviorSubject<Boolean>(false);
    rejectAllRecommendationsCompleteSource = new BehaviorSubject<Boolean>(false);
    rejectAllRecommendationsIsLoadingSource = new BehaviorSubject<Boolean>(false);
    rejectAllRecommendationsHasFailedSource = new BehaviorSubject<Boolean>(false);

    priceLadderHasFailedSource = new BehaviorSubject<Boolean>(false);
    reviseHasFailedSource = new BehaviorSubject<Boolean>(false);

    //Observables
    recommendationsHasFailed$: Observable<Boolean> = this.recommendationsHasFailedSource.asObservable();
    acceptRecommendationHasFailed$: Observable<Boolean> = this.acceptRecommendationHasFailedSource.asObservable();
    rejectRecommendationHasFailed$: Observable<Boolean> = this.rejectRecommendationHasFailedSource.asObservable();

    acceptAllRecommendationsComplete$: Observable<Boolean> = this.acceptAllRecommendationsCompleteSource.asObservable();
    acceptAllRecommendationsIsLoading$: Observable<Boolean> = this.acceptAllRecommendationsIsLoadingSource.asObservable();
    acceptAllRecommendationsHasFailed$: Observable<Boolean> = this.acceptAllRecommendationsHasFailedSource.asObservable();
    rejectAllRecommendationsComplete$: Observable<Boolean> = this.rejectAllRecommendationsCompleteSource.asObservable();
    rejectAllRecommendationsIsLoading$: Observable<Boolean> = this.rejectAllRecommendationsIsLoadingSource.asObservable();
    rejectAllRecommendationsHasFailed$: Observable<Boolean> = this.rejectAllRecommendationsHasFailedSource.asObservable();

    priceLadderHasFailed$: Observable<Boolean> = this.priceLadderHasFailedSource.asObservable();
    reviseHasFailed$: Observable<Boolean> = this.reviseHasFailedSource.asObservable();

    resetAcceptAllRecommendationsHasFailed() {}
    resetRejectAllRecommendationsHasFailed() {}
    resetAcceptRecommendationHasFailed() {}
    resetRejectRecommendationHasFailed() {}
    resetAcceptAllRecommendationsComplete() {}
    resetRejectAllRecommendationsComplete() {}
    resetReviseRecommendationHasFailed() {}

}

describe('ScenarioWorkspaceNotificationsComponent', () => {
  let component: ScenarioWorkspaceNotificationsComponent;
  let fixture: ComponentFixture<ScenarioWorkspaceNotificationsComponent>;
  let model;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ScenarioWorkspaceNotificationsComponent ],
      imports: [
        NgSpinKitModule,
        TranslateModule.forRoot({
          loader: { provide: TranslateLoader, useClass: TranslateFakeLoader }
        }),
      ],
    })
    .overrideComponent(ScenarioWorkspaceNotificationsComponent, {
    set: {
      providers: [
        { provide: RecommendationsModel, useClass: MockRecommendationsModel }
      ],
    }})
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ScenarioWorkspaceNotificationsComponent);
    component = fixture.componentInstance;
    model = fixture.debugElement.injector.get(RecommendationsModel);
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });

  it('should call the reset model functions', () => {
    spyOn(model, 'resetAcceptAllRecommendationsHasFailed');
    spyOn(model, 'resetRejectAllRecommendationsHasFailed');
    spyOn(model, 'resetAcceptRecommendationHasFailed');
    spyOn(model, 'resetRejectRecommendationHasFailed');
    spyOn(model, 'resetReviseRecommendationHasFailed');
    component.dismissAcceptAllRecommendationsHasFailed();
    expect(model.resetAcceptAllRecommendationsHasFailed).toHaveBeenCalled();
    component.dismissRejectAllRecommendationsHasFailed();
    expect(model.resetRejectAllRecommendationsHasFailed).toHaveBeenCalled();
    component.dismissAcceptRecommendationHasFailed();
    expect(model.resetAcceptRecommendationHasFailed).toHaveBeenCalled();
    component.dismissRejectRecommendationHasFailed();
    expect(model.resetRejectRecommendationHasFailed).toHaveBeenCalled();
    component.dismissReviseRecommendationHasFailed();
    expect(model.resetReviseRecommendationHasFailed).toHaveBeenCalled();
  });

  it('should show the grid when recommendationsHasFailed is false', () => {
    spyOn(component.showGridChange, 'emit');
    model.recommendationsHasFailedSource.next(false);
    expect(component.showGridChange.emit).toHaveBeenCalledWith(true);
  });

  it('should hide the grid when recommendationsHasFailed', () => {
    spyOn(component.showGridChange, 'emit');
    model.recommendationsHasFailedSource.next(true);
    expect(component.showGridChange.emit).toHaveBeenCalledWith(false);
  });

  it('should reset and dismiss all notifications upon leaving the workspace', () => {
    spyOn(component, 'dismissAcceptAllRecommendationsHasFailed');
    spyOn(component, 'dismissRejectAllRecommendationsHasFailed');
    spyOn(component, 'dismissAcceptRecommendationHasFailed');
    spyOn(component, 'dismissRejectRecommendationHasFailed');
    spyOn(component, 'dismissAcceptAllRecommendationsComplete');
    spyOn(component, 'dismissRejectAllRecommendationsComplete');
    spyOn(component, 'dismissReviseRecommendationHasFailed');

    component.dismissAllNotifications();

    expect(component.dismissAcceptAllRecommendationsHasFailed).toHaveBeenCalled();
    expect(component.dismissRejectAllRecommendationsHasFailed).toHaveBeenCalled();
    expect(component.dismissAcceptRecommendationHasFailed).toHaveBeenCalled();
    expect(component.dismissRejectRecommendationHasFailed).toHaveBeenCalled();
    expect(component.dismissAcceptAllRecommendationsComplete).toHaveBeenCalled();
    expect(component.dismissRejectAllRecommendationsComplete).toHaveBeenCalled();
    expect(component.dismissReviseRecommendationHasFailed).toHaveBeenCalled();
  });

});
