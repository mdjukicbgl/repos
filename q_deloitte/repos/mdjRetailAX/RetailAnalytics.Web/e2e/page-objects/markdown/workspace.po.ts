import { browser, element, by } from 'protractor';

export class WorkspacePage {
  navigateTo() {
    return browser.get('/markdown/workspace');
  }

  getUrl(){
      return browser.getCurrentUrl();
  }
  
}