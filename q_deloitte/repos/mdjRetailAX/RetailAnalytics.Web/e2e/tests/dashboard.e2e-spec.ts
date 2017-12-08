import { DashboardPage } from '../page-objects/dashboard.po';

describe('Dashboard Page', function() {
  let page: DashboardPage;

  beforeEach(() => {
    page = new DashboardPage();
  });

  it('should display message saying Welcome to Deloitte. Markdown V3', () => {
    page.navigateTo();
    expect<any>(page.getHeaderText()).toEqual('Welcome to Deloitte. Markdown V3');
  });
});
