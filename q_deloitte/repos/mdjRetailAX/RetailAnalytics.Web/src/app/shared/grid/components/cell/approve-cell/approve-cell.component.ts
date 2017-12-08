import { GridUtils } from '../../../utils/grid-utils';
import { Component } from '@angular/core';

@Component({
  selector: 'app-approve-cell',
  templateUrl: './approve-cell.component.html',
})
export class ApproveCellComponent {
    params: any;
    state: string;
    data: any;

    constructor( private gridUtils: GridUtils ) {
      this.gridUtils = gridUtils;
    }

    agInit(params: any): void {
        this.params = params;
        this.data = params.data;
        this.state = params.value;
    }

    stateChange(): void {
      switch (this.state) {
        case 'REJECTED':
            this.params.context.componentParent._model.acceptRecommendation(
              this.data.scenarioId, this.data.recommendationGuid
            );
            break;
        case 'ACCEPTED':
            this.params.context.componentParent._model.rejectRecommendation(
              this.data.scenarioId, this.data.recommendationGuid
            );
            break;
        case 'REVISED':
            this.params.context.componentParent._model.rejectRecommendation(
              this.data.scenarioId, this.data.recommendationGuid
            );
            break;
        case 'NEUTRAL':
            this.params.context.componentParent._model.acceptRecommendation(
              this.data.scenarioId, this.data.recommendationGuid
            );
            break;
        default:
            return;
      }

    }
}
