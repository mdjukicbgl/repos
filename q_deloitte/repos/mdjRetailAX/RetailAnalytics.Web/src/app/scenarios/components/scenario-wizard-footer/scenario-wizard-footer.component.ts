import { Component, OnInit, EventEmitter, Output } from '@angular/core';

@Component({
  selector: 'app-scenario-wizard-footer',
  templateUrl: './scenario-wizard-footer.component.html',
  styleUrls: ['./scenario-wizard-footer.component.scss']
})
export class ScenarioWizardFooterComponent implements OnInit {

  @Output() onSaveClick: EventEmitter<any> = new EventEmitter();
  @Output() onSaveAndRunClick: EventEmitter<any> = new EventEmitter();

  constructor() { }

  ngOnInit() {
  }

  onSaveClicked() {
    this.onSaveClick.emit();
  }

  onSaveAndRunClicked() {
    this.onSaveAndRunClick.emit();
  }

}
