import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RecommendationsComponent } from './recommendations.component';
import { ScenarioWorkspaceComponent } from './components/scenario-workspace/scenario-workspace.component';


@NgModule({
  imports: [RouterModule.forChild([
    { path: '', component: ScenarioWorkspaceComponent,
      children : [
        { path: ':id', component: ScenarioWorkspaceComponent },
      ]
    }
  ])],
  exports: [RouterModule]
})
export class RecommendationsRoutingModule {}
