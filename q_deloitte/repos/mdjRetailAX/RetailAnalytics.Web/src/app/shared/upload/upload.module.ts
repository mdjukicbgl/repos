import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AlertsModule } from '../alerts/alerts.module';
import { EffectsModule } from '@ngrx/effects';
import { UploadEffects } from './effects/upload.effects';
import { TranslateModule } from '@ngx-translate/core';
import { FileUploadComponent } from './components/file-upload/file-upload.component';

@NgModule({
    imports: [
        CommonModule,
        AlertsModule,
        EffectsModule.run(UploadEffects),
        TranslateModule
    ],
    declarations: [
        FileUploadComponent,
    ],
    exports: [
        FileUploadComponent
    ],
})
export class UploadModule { }
