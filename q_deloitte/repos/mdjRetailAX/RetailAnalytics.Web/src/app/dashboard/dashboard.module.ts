import { HttpModule } from '@angular/http';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { BrowserModule } from '@angular/platform-browser';
import { CommonModule } from '@angular/common';
import { EffectsModule } from '@ngrx/effects';

import { DashboardRoutingModule } from './dashboard-routing.module';
import { DashboardComponent } from './dashboard.component';
import { StoreMgmtModule } from '../shared/store-mgmt/store-mgmt.module';
import { NgSpinKitModule } from 'ng-spin-kit';
import { DashboardEffects } from './effects/dashboard.effects';
import { NavigationModule } from '../shared/navigation/navigation.module';

import { WidgetFactoryComponent } from './components/widget-factory/widget-factory.component';
import { ScenariosWidgetComponent } from './components/widget/scenarios-widget/scenarios-widget.component';
import { WidgetHostDirective} from './directives/widget-host.directive';
import { TranslateModule } from '@ngx-translate/core';

@NgModule({
    imports: [
        CommonModule,
        DashboardRoutingModule,
        StoreMgmtModule,
        EffectsModule.run(DashboardEffects),
        NgSpinKitModule,
        NavigationModule,
        TranslateModule.forChild({})
    ],
    declarations: [
        DashboardComponent,
        WidgetFactoryComponent,
        WidgetHostDirective,
        ScenariosWidgetComponent,
    ],
    entryComponents: [ ScenariosWidgetComponent ],
    providers: [

    ],
})
export class DashboardModule { }
