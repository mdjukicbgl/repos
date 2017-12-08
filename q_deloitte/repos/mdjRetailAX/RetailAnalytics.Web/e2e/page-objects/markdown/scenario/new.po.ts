import { browser, element, by } from 'protractor';

export class NewScenarioPage {
  navigateTo() {
    return browser.get('/markdown/scenarios/new');
  }

  getUrl(){
    return browser.getCurrentUrl();
  }

  scenarioNameTextbox() {
    return element(by.css('input[name=\'scenarioName\']'));
  }

  scheduleWeekCheckboxes(i){
    element.all(by.css('label.form-check-label[_ngcontent-c7=\'\']')).map(function(checkbox){
    return checkbox[i].click();
  });
  }
  
}