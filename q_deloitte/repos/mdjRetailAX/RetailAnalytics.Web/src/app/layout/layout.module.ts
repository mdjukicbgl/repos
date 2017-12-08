import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavigationModule } from '../shared/navigation/navigation.module';
import { LayoutRoutingModule } from './layout-routing.module';
import { LayoutComponent } from './layout.component';

@NgModule({
    imports: [
        CommonModule,
        LayoutRoutingModule,
        NavigationModule,
    ],
    declarations: [
        LayoutComponent,
    ]
})
export class LayoutModule { }
