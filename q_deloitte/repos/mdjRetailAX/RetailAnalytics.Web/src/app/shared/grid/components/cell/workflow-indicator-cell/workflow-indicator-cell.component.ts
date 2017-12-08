import { Component } from '@angular/core';

@Component({
  selector: 'app-workflow-indicator-cell',
  template: `
  <div>
    <span *ngIf="params.value === false" class="icon-selector"></span>
    <span *ngIf="params.value === true" class="icon-selector-active"></span>
  </div>`,
  styleUrls: ['./workflow-indicator-cell.component.scss'],
})
export class WorkflowIndicatorCellComponent {
    params: any;

    agInit(params: any): void {
        this.params = params;
    }
}
