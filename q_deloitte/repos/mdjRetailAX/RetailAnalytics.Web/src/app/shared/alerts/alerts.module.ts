import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SuccessGroupComponent } from './success-group/success-group.component';
import { ErrorGroupComponent } from './error-group/error-group.component';

@NgModule({
    imports: [
        CommonModule,
     ],
    declarations: [
        ErrorGroupComponent,
        SuccessGroupComponent
    ],
    exports: [
        ErrorGroupComponent,
        SuccessGroupComponent
    ]
})

export class AlertsModule {}
