import { Component } from '@angular/core';

@Component({
  selector: 'app-measure-cell',
  template: `
  <div *ngIf="params.node.data.status === 'Complete'">
    <div>
      <span>{{ 'SCENARIOS.MEASURES.NUMBER_OF_PRODUCTS' | translate }}</span>
      <span class="value">{{ params.node.data.totalNumberRecommendedProducts }}</span>
    </div>
    <div>
      <span>{{ 'SCENARIOS.MEASURES.ESTIMATED_SALES' | translate }} &pound;</span>
      <span class="value">{{ params.node.data.markdownCost.toFixed(2)}}</span>
    </div>
  </div>`,
  styleUrls: ['./measure-cell.component.scss'],
})
export class MeasureCellComponent {
    params: any;

    agInit(params: any): void {
        this.params = params;
    }
}
