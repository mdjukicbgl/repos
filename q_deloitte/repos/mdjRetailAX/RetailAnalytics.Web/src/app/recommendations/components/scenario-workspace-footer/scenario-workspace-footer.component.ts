import { GridOptions, RowNode } from 'ag-grid/main';
import { ReviseService } from '../../services/revise.service';
import { ScenarioProductRecommendation } from '../../models/recommendations.entity';
import { RecommendationsModel } from '../../models/recommendations.model';
import { Component, Input, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs/Subscription';
import { Observable } from 'rxjs/Observable';

@Component({
  selector: 'app-scenario-workspace-footer',
  templateUrl: './scenario-workspace-footer.component.html',
  styleUrls: ['./scenario-workspace-footer.component.scss'],
})
export class ScenarioWorkspaceFooterComponent implements OnDestroy {

  @Input() disable: Boolean;
  @Input() gridOptions: GridOptions;
  @Input() selectedRecommendations: RowNode[];

  _subscriptions: Array<Subscription> = [];

  constructor(private reviseService: ReviseService, private _model: RecommendationsModel) {}

  onAcceptClicked() {
    this.selectedRecommendations.forEach(recommendation => {
      this._model.acceptRecommendation(recommendation.data.scenarioId, recommendation.data.recommendationGuid)
    });
  }

  onRejectClicked() {
    this.selectedRecommendations.forEach(recommendation => {
      this._model.rejectRecommendation(recommendation.data.scenarioId, recommendation.data.recommendationGuid)
    });
  }

  onUpdateClicked() {
    this.selectedRecommendations.forEach(recommendation => {
      this.reviseService.revise(recommendation, this.gridOptions);
    });
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }

}
