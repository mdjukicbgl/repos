
import { Observable } from 'rxjs/Observable';
import { Component, OnInit, ChangeDetectionStrategy, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { Subscription } from 'rxjs/Rx';

import { DashboardModel } from '../../../models/dashboard.model';
import { Scenario } from '../../../../scenarios/models/scenarios.entity';
import { Widget } from '../../../models/widget.entity';

import groupBy from 'lodash-es/groupBy';
import map from 'lodash-es/map';
import filter from 'lodash-es/filter';

@Component({
  selector: 'app-scenarios-widget',
  templateUrl: './scenarios-widget.component.html',
  styleUrls: ['./scenarios-widget.component.scss'],
  providers: [ DashboardModel ],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ScenariosWidgetComponent implements OnInit, OnDestroy {

  widget: Widget;
  scenarios$: Observable<Scenario[]>;
  isLoadingScenarios$: Observable<boolean>;
  hasLoadingScenariosFailed$: Observable<boolean>;
  _subscription: Subscription;

  // Calculated
  scenariosGrouped$: Observable<any>;
  scenariosPerWeek$: Observable<number>;

  constructor(private _model: DashboardModel, private router: Router ) {
    this.scenarios$ = _model.scenarios$;
    this.isLoadingScenarios$ = _model.isLoadingScenarios$;
    this.hasLoadingScenariosFailed$ = _model.hasLoadingScenariosFailed$;
  }

  ngOnInit() {
    this._model.loadScenarios();

    this._subscription = this.scenarios$.skip(1).subscribe(
      value => {
        this.scenariosGrouped$ = Observable.of(this.groupScenariosByStatus(value));
        this.scenariosPerWeek$ = Observable.of(this.calculateScenariosPerWeek(value));
      }
    );
  }

  groupScenariosByStatus(scenarios: Scenario[]) {
      return map(groupBy(scenarios, x => x.status), (value, key) => ({status: key, scenarios: value}));
  }

  calculateScenariosPerWeek(scenarios: Scenario[]) {
    return filter(scenarios, (data) => {
        let lastWeek = this.createDate(-7, 0, 0);
        if (data.lastRunDate) {
          return (new Date(data.lastRunDate) > lastWeek);
        }
        return false;
    }).length;
  }

  navigateToScenarios(status: string) {
    this.router.navigate(['/markdown/scenarios', { status: status }]);
  }

  createDate(days, months, years) {
    let date = new Date();
    date.setDate(date.getDate() + days);
    date.setMonth(date.getMonth() + months);
    date.setFullYear(date.getFullYear() + years);
    return date;
  }

  ngOnDestroy() {
    this._subscription.unsubscribe();
  }

}
