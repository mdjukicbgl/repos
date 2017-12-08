import { Router } from '@angular/router';
import { Scenario } from '../../models/scenarios.entity';
import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-scenario-summary-footer',
  templateUrl: './scenario-summary-footer.component.html',
  styleUrls: ['./scenario-summary-footer.component.scss']
})
export class ScenarioSummaryFooterComponent {

  @Input() selectedScenario: Scenario;
  @Output() openRunModal: EventEmitter<any> = new EventEmitter();

  constructor(private router: Router) { }

  onWorkspaceClick() {
    if ( this.selectedScenario.status === 'Complete') {
      this.router.navigate(['/markdown/workspace', { scenarioId: this.selectedScenario.scenarioId }]);
    }
  }

  onRunClick() {
    if ( this.selectedScenario.status === 'New') {
      this.openRunModal.emit(this.selectedScenario.scenarioId);
    }
  }

}
