import { DashboardPage } from '../page-objects/dashboard.po';
import { Header } from '../page-objects/header.po';
import { ScenarioPage } from '../page-objects/markdown/scenario.po';
import { WorkspacePage } from '../page-objects/markdown/workspace.po';
import { NewScenarioPage } from '../page-objects/markdown/scenario/new.po';

describe('A Markdown User', function() {
  let dashboardPage: DashboardPage;
  let header: Header;
  let scenarioPage: ScenarioPage;
  let workspacePage: WorkspacePage;
  let newScenarioPage: NewScenarioPage;

  beforeEach(() => {
    dashboardPage = new DashboardPage();
    header = new Header();
    scenarioPage = new ScenarioPage();
    workspacePage = new WorkspacePage();
    newScenarioPage = new NewScenarioPage();
  });

  it('should be able to navigate the site from the header', () => {
    dashboardPage.navigateTo();
    header.clickScenario();
    expect<any>(scenarioPage.getUrl()).toContain('markdown/scenarios');
    header.clickWorkspace();
    expect<any>(workspacePage.getUrl()).toContain('markdown/workspace');
    header.clickDashboard();
    expect<any>(scenarioPage.getUrl()).toContain('dashboard');
  });

  it('should be able to create a new scenario', () => {
    dashboardPage.navigateTo();
    header.clickScenario();
    expect<any>(scenarioPage.createScenarioButton().isDisplayed()).toBe(true);
    scenarioPage.createScenarioButton().click();
    expect<any>(newScenarioPage.getUrl()).toContain('new');
  });

});
