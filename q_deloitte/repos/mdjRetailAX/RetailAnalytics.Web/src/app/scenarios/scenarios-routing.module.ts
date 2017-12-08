import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { ScenariosComponent } from './scenarios.component';
import { ScenarioSummaryComponent } from './components/scenario-summary/scenario-summary.component';
import { ScenarioEditComponent } from './components/scenario-edit/scenario-edit.component';


@NgModule({
  imports: [ RouterModule.forChild([
    { path: '', component: ScenariosComponent,
      children : [
        { path: 'scenarios', component: ScenarioSummaryComponent },
        { path: 'scenario/new', component: ScenarioEditComponent },
        { path: 'scenario/edit/:id', component: ScenarioEditComponent }
      ]
    }
  ])],
  exports: [ RouterModule ]
})
export class ScenariosRoutingModule {}
