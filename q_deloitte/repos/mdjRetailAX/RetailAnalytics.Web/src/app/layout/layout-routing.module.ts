import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { LayoutComponent } from './layout.component';
import { AuthGuard } from '../shared/auth/auth-guard.service';
import { Auth } from '../shared/auth/auth.service';

const routes: Routes = [
    {
        path: '', 
        component: LayoutComponent,
        children: [
            { path: 'dashboard', loadChildren: 'app/dashboard/dashboard.module#DashboardModule' },
            { path: 'markdown', loadChildren: 'app/scenarios/scenarios.module#ScenariosModule', canActivate: [AuthGuard]},
            { path: 'markdown/workspace', loadChildren: 'app/recommendations/recommendations.module#RecommendationsModule', canActivate: [AuthGuard]}
        ]
    }
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule]
})
export class LayoutRoutingModule { }
