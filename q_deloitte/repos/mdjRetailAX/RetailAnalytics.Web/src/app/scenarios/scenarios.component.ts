import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { Component, OnInit } from '@angular/core';

import { ScenariosModel } from './models/scenarios.model';
import { Scenario } from './models/scenarios.entity';

@Component({
    selector: 'scenarios',
    template: `<router-outlet></router-outlet>`,
    providers: [ ScenariosModel ],
    host: { 'class': 'vertical-flex' },
})

export class ScenariosComponent implements OnInit {

    constructor(private _model: ScenariosModel) {

    }

    ngOnInit() {

    }

}
