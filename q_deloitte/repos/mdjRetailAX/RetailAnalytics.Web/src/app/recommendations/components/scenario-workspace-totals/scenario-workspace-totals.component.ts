import { TranslateService } from '@ngx-translate/core';
import { LocaleUtil } from '../../../shared/utils/locale-util/locale-util';
import { Scenario } from '../../../scenarios/models/scenarios.entity';
import { Observable, Subscription } from 'rxjs/Rx';
import { Component, Input, OnDestroy, AfterViewInit } from '@angular/core';
import { ScenariosModel } from '../../../scenarios/models/scenarios.model';

@Component({
  selector: 'app-scenario-workspace-totals',
  templateUrl: './scenario-workspace-totals.component.html',
  styleUrls: ['./scenario-workspace-totals.component.scss']
})

export class ScenarioWorkspaceTotalsComponent implements AfterViewInit, OnDestroy {

  @Input() selectedScenarioId: number;

  _subscriptions: Array<Subscription> = [];
  selectedScenario$: Observable<Scenario>;
  locale: string;

  constructor(
    private _scenario_model: ScenariosModel,
    private translate: TranslateService,
    private localeUtil: LocaleUtil) {
    this.selectedScenario$ = this._scenario_model.selectedScenario$;
    this._subscriptions.push(this.translate.onLangChange.subscribe(() => {
      this.locale = this.localeUtil.getCurrentLocale();
    }));
    this.locale = this.localeUtil.getCurrentLocale();
  }

  ngAfterViewInit() {
    if (this.selectedScenarioId) {
      this.loadSelectedScenario();
    }
  }

  loadSelectedScenario() {
    this._scenario_model.loadSelectedScenario(this.selectedScenarioId);
  }

  ngOnDestroy() {
    this._subscriptions.forEach((sub) => sub.unsubscribe());
  }

}
