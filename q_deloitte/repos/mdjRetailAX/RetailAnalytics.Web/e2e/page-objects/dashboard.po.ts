import { browser, element, by } from 'protractor';

export class DashboardPage {
  navigateTo() {
    return browser.get('/dashboard');
  }

  getHeaderText() {
    return element(by.css('app-dashboard h1')).getText();
  }

  getUrl(){
    return browser.getCurrentUrl();
  }
}
