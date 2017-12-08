import { Component, OnInit } from '@angular/core';
import { correctHeight, detectBody } from './app.helpers';
import { Router } from '@angular/router';
import { Store } from '@ngrx/store';

import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { StoreMgmtService } from './shared/store-mgmt/store-mgmt.service';
import { appReducer, AppState } from './app.reducer';

import { OAuthService } from 'angular-oauth2-oidc';
import { TranslateService } from '@ngx-translate/core';
import { LocaleService } from 'angular-l10n';
import { environment } from '../environments/environment';
import { Auth } from './shared/auth/auth.service';

@Component({
    selector: 'pf-retail-analytics-app',
    template: `<router-outlet></router-outlet>`,
    styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {

    errorMessage: string;

    constructor(private auth: Auth,
                storeMgmtService: StoreMgmtService,
                public store: Store<AppState>,
                private translate: TranslateService,
                public locale: LocaleService) {

        this.initTranslations();

        storeMgmtService.addReducers(appReducer);
    }

    ngOnInit()
    {
        this.auth.checkLogin();
    }

    Login() {
        this.auth.login();
    }

    Logout() {
        this.auth.logout();
    }

    initTranslations() {
      this.translate.addLangs(['en-GB', 'bg-BG']);
      this.translate.setDefaultLang('en-GB');
      this.translate.use('en-GB');

      this.locale.addConfiguration()
            .defineDefaultLocale('en', 'GB');
    }

}
