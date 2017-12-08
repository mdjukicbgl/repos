import { Router } from '@angular/router';
import { Component } from '@angular/core';

import { ICellRendererAngularComp } from 'ag-grid-angular/main';

@Component({
    selector: 'create-scenario-full-width',
    template: `<div class="text-center create-scenario" (click)="onClick($event)"><i class="fa fa-plus-circle"></i> {{ 'SCENARIOS.SUMMARY.CREATE_NEW' | translate }}</div>`,
    styleUrls: ['create-scenario.component.scss']
})
export class CreateScenarioRendererComponent implements ICellRendererAngularComp {
    private params: any;

    constructor(private router: Router) {

    }

    agInit(params: any): void {
        this.params = params;
    }

    onClick($event) {
      this.router.navigate(['/markdown/scenario/new']);
    }

    refresh(params: any) {
      return false;
    }
}
