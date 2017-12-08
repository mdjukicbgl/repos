Feature: Cucumber tests
    As a Markdown Team Member
    I should be able to read BDD feature files
    In order for the whole team to be cross functional

    Scenario: The header links work
  Given I go to Markdown
   When I click "Scenario" in the header
   Then the "Scenarios" Page will load
   When I click "Workspace" in the header
   Then the "Workspace" Page will load
   When I click "Dashboard" in the header
   Then the "Dashboard" Page will load

   Scenario: A user can create a new scenario
   Given I go to Markdown
   When I click "Scenario" in the header
   Then the Create Scenario Button should be displayed
   When I click the Create Scenario Button
   Then the "New" Page will load