import { Router } from '@angular/router';
import { Component } from '@angular/core';

@Component({
  selector: 'app-status-cell',
  templateUrl: './status-cell.component.html',
  styleUrls: ['./status-cell.component.scss'],
})
export class StatusCellComponent {
    params: any;

    constructor(private router: Router) { }

    agInit(params: any): void {
      this.params = params;
    }

    runClick(node): void {
      this.params.context.componentParent.showRunModal(node);
    }

    completeClick(node): void {
      if ( node.data && node.data.status === 'Complete') {
        this.router.navigate(['/markdown/workspace', { scenarioId: node.data.scenarioId }]);
      }
    }
}
