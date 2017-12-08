import { browser, element, by } from 'protractor';

export class ScenarioPage {
  navigateTo() {
    return browser.get('/markdown/scenarios');
  }

  createScenarioButton() {
    return element(by.css('button.ml-1'));
  }

  getUrl(){
      return browser.getCurrentUrl();
  }
}