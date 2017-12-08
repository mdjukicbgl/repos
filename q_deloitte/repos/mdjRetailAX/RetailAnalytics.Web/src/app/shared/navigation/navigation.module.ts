import { NgbDropdownModule } from '@ng-bootstrap/ng-bootstrap/dropdown/dropdown.module';
import { HeaderRoutingModule } from './header/header-routing.module';
import { Routes, RouterModule } from '@angular/router';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HeaderComponent } from './header/header.component';
import { SubNavComponent } from './subnav/subnav.component';
import { SubNavLinkComponent } from './subnav-link/subnav-link.component';
import { ProfileDropdownComponent } from './profile-dropdown/profile-dropdown.component';
import { TranslateModule } from '@ngx-translate/core';
import { UserPreferencesModule } from '../user-preferences/user-preferences.module'

@NgModule({
    imports: [
        CommonModule,
        HeaderRoutingModule,
        NgbDropdownModule.forRoot(),
        TranslateModule,
        UserPreferencesModule
     ],
    declarations: [
        HeaderComponent,
        SubNavComponent,
        SubNavLinkComponent,
        ProfileDropdownComponent,
    ],
    exports: [
        HeaderComponent,
        SubNavComponent,
        SubNavLinkComponent,
    ]
})

export class NavigationModule {}
