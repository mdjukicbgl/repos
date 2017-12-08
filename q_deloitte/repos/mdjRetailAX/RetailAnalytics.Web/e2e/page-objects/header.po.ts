import { browser, element, by } from 'protractor';

export class Header {

  dashboardLink() {
    return element(by.css('app-header .secondary-nav__link[routerlink=\'/dashboard\']'));
  }

    scenarioLink() {
    return element(by.css('app-header .secondary-nav__link[routerlink=\'/markdown/scenarios\']'));
  }

    workspaceLink() {
    return element(by.css('app-header .secondary-nav__link[routerlink=\'/markdown/workspace\']'));
  }

}