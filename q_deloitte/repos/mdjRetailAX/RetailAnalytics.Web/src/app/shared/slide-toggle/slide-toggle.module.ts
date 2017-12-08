import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SlideToggleComponent } from './slide-toggle.component';

@NgModule({
    imports: [
        CommonModule,
     ],
    declarations: [
        SlideToggleComponent,
    ],
    exports: [
        SlideToggleComponent,
    ]
})

export class SlideToggleModule {}
