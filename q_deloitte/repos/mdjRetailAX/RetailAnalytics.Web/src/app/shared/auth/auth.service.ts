import { Injectable } from '@angular/core';
import { JwtHelper } from 'angular2-jwt';
import { environment } from '../../../environments/environment';
import { OAuthService } from 'angular-oauth2-oidc';

@Injectable()
export class Auth {
  constructor(private oauthService: OAuthService) {


       // URL of the SPA to redirect the user to after login
        this.oauthService.redirectUri = window.location.origin + "/dashboard";

        // The SPA's id. The SPA is registerd with this id at the auth-server
        this.oauthService.clientId = environment.oidc.clientId;

        // set the scope for the permissions the client should request
        // The first three are defined by OIDC. The 4th is a usecase-specific one
        this.oauthService.scope = environment.oidc.scope;

        // set to true, to receive also an id_token via OpenId Connect (OIDC) in addition to the
        // OAuth2-based access_token
        this.oauthService.oidc = environment.oidc.recieveOidcToken;

        // Use setStorage to use sessionStorage or another implementation of the TS-type Storage
        // instead of localStorage
        this.oauthService.setStorage(sessionStorage);

        // The name of the auth-server that has to be mentioned within the token
        this.oauthService.issuer = environment.oidc.issuer;

  }

  checkLogin() {
    // Load Discovery Document and then try to login the user
    this.oauthService.loadDiscoveryDocument().then(() => {
        console.log("Loaded Discovery Document");
        // This method just tries to parse the token(s) within the url when
        // the auth-server redirects the user back to the web-app
        // It dosn't send the user the the login page
        let loggedIn = this.oauthService.tryLogin({
            onTokenReceived: context => {
                console.debug("logged in");
            }
        });

        if (!this.oauthService.hasValidIdToken()) {
            this.login();
        }

    });
  }

  loggedIn() : boolean {
      let jwtHelper: JwtHelper = new JwtHelper();
      let token = sessionStorage.getItem(environment.oidc.tokenName);
      return !jwtHelper.isTokenExpired(token)
  }

  login() {
    this.oauthService.initImplicitFlow();
  }

  logout() {
    this.oauthService.logOut();
  }

  getName() : string {
      let idClaim = this.oauthService.getIdentityClaims();
      if (idClaim != null) {
          return idClaim.name;
      } else {
        return "Unknown";
      }
  }
}

