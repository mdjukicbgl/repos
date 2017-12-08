import { ScenarioPage } from '../page-objects/markdown/scenario.po';
import { NewScenarioPage } from '../page-objects/markdown/scenario/new.po';

describe('The New Scenario page', function() {
  let scenarioPage: ScenarioPage;
  let newScenarioPage: NewScenarioPage;

  beforeEach(() => {
    scenarioPage = new ScenarioPage();
    newScenarioPage = new NewScenarioPage();
  });

  it('should allow users to specify the scenario name and set the schedule', () => {
    scenarioPage.navigateTo();
    scenarioPage.createScenarioButton().click();
    expect<any>(newScenarioPage.scenarioNameTextbox().isDisplayed()).toBe(true);
    newScenarioPage.scenarioNameTextbox().sendKeys('Test Scenario');
    for(var i = 0; i < 8; i++) {
        newScenarioPage.scheduleWeekCheckboxes(i);
    }
  });

});
