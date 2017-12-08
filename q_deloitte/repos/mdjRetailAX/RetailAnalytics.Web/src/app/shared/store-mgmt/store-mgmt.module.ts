import {NgModule, ModuleWithProviders} from '@angular/core';
import {StoreMgmtService} from './store-mgmt.service';

@NgModule({})
export class StoreMgmtModule {
    static forRoot(): ModuleWithProviders {
        return {
            ngModule: StoreMgmtModule,
            providers: [StoreMgmtService]
        };
    }
}
