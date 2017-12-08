import { RecommendationsModel } from '../../models/recommendations.model';
import { Component, Input, Output, EventEmitter, OnInit, OnDestroy } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { Subscription } from 'rxjs/Subscription';

@Component({
  selector: 'app-scenario-workspace-notifications',
  templateUrl: './scenario-workspace-notifications.component.html',
  styles: [`i { cursor: pointer;}`],
  providers: [ RecommendationsModel ]
})
export class ScenarioWorkspaceNotificationsComponent implements OnInit, OnDestroy {

  @Input() hasNoSelectedScenario = false;
  @Output() showGridChange: EventEmitter<any> = new EventEmitter();

  recommendationsHasFailed$: Observable<boolean>;

  acceptRecommendationHasFailed$: Observable<boolean>;
  rejectRecommendationHasFailed$: Observable<boolean>;

  acceptAllRecommendationsComplete$: Observable<boolean>;
  acceptAllRecommendationsIsLoading$: Observable<boolean>;
  acceptAllRecommendationsHasFailed$: Observable<boolean>;

  rejectAllRecommendationsComplete$: Observable<boolean>;
  rejectAllRecommendationsIsLoading$: Observable<boolean>;
  rejectAllRecommendationsHasFailed$: Observable<boolean>;

  priceLadderHasFailed$: Observable<boolean>;

  reviseHasFailed$: Observable<boolean>;

  _subscriptions: Array<Subscription> = [];

  constructor(private _model: RecommendationsModel) {

    this.recommendationsHasFailed$ = _model.recommendationsHasFailed$;

    this.acceptRecommendationHasFailed$ = _model.acceptRecommendationHasFailed$;
    this.rejectRecommendationHasFailed$ = _model.rejectRecommendationHasFailed$;

    this.acceptAllRecommendationsComplete$ = _model.acceptAllRecommendationsComplete$;
    this.acceptAllRecommendationsIsLoading$ = _model.acceptAllRecommendationsIsLoading$;
    this.acceptAllRecommendationsHasFailed$ = _model.acceptAllRecommendationsHasFailed$;

    this.rejectAllRecommendationsComplete$ = _model.rejectAllRecommendationsComplete$;
    this.rejectAllRecommendationsIsLoading$ = _model.rejectAllRecommendationsIsLoading$;
    this.rejectAllRecommendationsHasFailed$ = _model.rejectAllRecommendationsHasFailed$;

    this.priceLadderHasFailed$ = _model.priceLadderHasFailed$;
    this.reviseHasFailed$ = _model.reviseHasFailed$;

  };

  ngOnInit() {

    let combined = Observable.combineLatest(
      this.recommendationsHasFailed$
    );

    this._subscriptions.push(combined.subscribe(latestValues => {
        this.checkGridVisibility(latestValues);
    }));
  }

  checkGridVisibility(latestValues) {
    const [
        recommendationsHasFailed
        ] = latestValues;

    /*
    *
    * There are some instance where we dont want to show the grid at all
    * i.e. No scenario selected, something 'global' is loading or the core fetch has failed
    * Some errors we wish to show above the grid
    * i.e. Accept/reject all failed, other in grid operations
    *
    */
    if (
        this.hasNoSelectedScenario ||
        recommendationsHasFailed
        ) {
      this.showGridChange.emit(false);
      return;
    }

    this.showGridChange.emit(true);

  }

  /* Reset error states */

  dismissAcceptAllRecommendationsHasFailed() {
    this._model.resetAcceptAllRecommendationsHasFailed();
  }

  dismissRejectAllRecommendationsHasFailed() {
    this._model.resetRejectAllRecommendationsHasFailed();
  }

  dismissAcceptRecommendationHasFailed() {
    this._model.resetAcceptRecommendationHasFailed();
  }

  dismissRejectRecommendationHasFailed() {
    this._model.resetRejectRecommendationHasFailed();
  }

  dismissAcceptAllRecommendationsComplete() {
    this._model.resetAcceptAllRecommendationsComplete();
  }

  dismissRejectAllRecommendationsComplete() {
    this._model.resetRejectAllRecommendationsComplete();
  }

  dismissReviseRecommendationHasFailed() {
    this._model.resetReviseRecommendationHasFailed();
  }

  /* Reset all */

  dismissAllNotifications() {
    this.dismissAcceptAllRecommendationsHasFailed();
    this.dismissRejectAllRecommendationsHasFailed();
    this.dismissAcceptRecommendationHasFailed();
    this.dismissRejectRecommendationHasFailed();
    this.dismissAcceptAllRecommendationsComplete();
    this.dismissRejectAllRecommendationsComplete();
    this.dismissReviseRecommendationHasFailed();
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
    this.dismissAllNotifications();
  }
}
