import { DashboardPage } from '../page-objects/dashboard.po';
import { Header } from '../page-objects/header.po';
import { ScenarioPage } from '../page-objects/markdown/scenario.po';
import { WorkspacePage } from '../page-objects/markdown/workspace.po';
import { NewScenarioPage } from '../page-objects/markdown/scenario/new.po';

import { defineSupportCode } from 'cucumber';
import { browser, element, by } from 'protractor';

let chai = require('chai').use(require('chai-as-promised'));
let expect = chai.expect;


defineSupportCode(function ({When, Then, Given, setDefaultTimeout}) {

let dashboardPage = new DashboardPage();
let header = new Header();
let scenarioPage = new ScenarioPage();
let workspacePage = new WorkspacePage();

Given('I go to Markdown', () => {
  // Write code here that turns the phrase above into concrete action
  return dashboardPage.navigateTo();
  });
Then('the welcome message is displayed', () => {
  // Write code here that turns the phrase above into concrete actions
  return expect(dashboardPage.getHeaderText()).to.eventually.equal('Welcome to Deloitte. Markdown V3');
});

When('I click {stringInDoubleQuotes} in the header', (stringInDoubleQuotes) => {
         // Write code here that turns the phrase above into concrete actions
        if(stringInDoubleQuotes === 'Scenario'){
        return header.scenarioLink().click();
      }
      if(stringInDoubleQuotes === 'Workspace'){
        return header.workspaceLink().click();
      }
      if(stringInDoubleQuotes === 'Dashboard'){
        return header.dashboardLink().click();
      }
      });
      
Then('the {stringInDoubleQuotes} Page will load', function (stringInDoubleQuotes) {
         // Write code here that turns the phrase above into concrete actions
         return expect(scenarioPage.getUrl()).to.eventually.contain(stringInDoubleQuotes.toLowerCase());
       });

       Then('the Create Scenario Button should be displayed', function () {
          // Write code here that turns the phrase above into concrete actions
          return expect(scenarioPage.createScenarioButton().isDisplayed()).to.eventually.equal(true);
        });

         When('I click the Create Scenario Button', function () {
          // Write code here that turns the phrase above into concrete actions
         return scenarioPage.createScenarioButton().click();
        });
})