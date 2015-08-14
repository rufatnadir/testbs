@rufat
@complete
@user
@ciready

Feature: Filter workspaces list

  Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

  Scenario: Filter workspaces by keyword
    Given User is on not filtered workspaces list
    When User input text "share" on search field
    Then Only workspaces containing word "share" displayed on list
    When User clears search field
    Then All workspaces will be displayed on list
    And Close screen

  Scenario: Sort workspaces by name
    Given User is on not filtered workspaces list
    When Click on sorting dropdown for workspaces
    When User select sorting by "Name"
    #Then Workspaces will be sorted alphabetically
    And Close screen