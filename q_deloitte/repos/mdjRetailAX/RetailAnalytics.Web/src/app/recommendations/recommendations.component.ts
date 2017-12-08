import { Store } from '@ngrx/store';
import { Observable } from 'rxjs/Observable';
import { Component, OnInit } from '@angular/core';

import { RecommendationsModel } from './models/recommendations.model';

@Component({
    selector: 'recommendations',
    template: `<router-outlet></router-outlet>`,
    providers: [ RecommendationsModel ],
    host: { 'class': 'vertical-flex' },
})

export class RecommendationsComponent implements OnInit {

    constructor(private _model: RecommendationsModel) {

    }

    ngOnInit() {

    }

}
