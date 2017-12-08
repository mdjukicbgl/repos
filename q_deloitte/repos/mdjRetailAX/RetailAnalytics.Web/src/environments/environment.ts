// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `angular-cli.json`.

export const environment = {
  production: false,
  apiUrl: "https://api.deloitteretailanalytics.deloittecloud.co.uk/api/",
  endpoint: "https://api.deloitteretailanalytics.deloittecloud.co.uk",  
  oidc: {
    clientId: "0oabdm86tepYaefOJ0h7",
    scope: "openid profile email",
    recieveOidcToken: true,
    useSessionStorage: true,
    issuer: "https://dev-317618.oktapreview.com",
    tokenName: "id_token"
  }
};
