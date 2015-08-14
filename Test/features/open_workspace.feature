Feature: Open workspace N times

  Scenario: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    And User substitutes on url "sessions" to "hub" and opens it
    #When User opens and closes workspace "LoadTestWorkspace" 20 times

  Scenario: Sort workspaces
    Given Click on sorting dropdown for workspaces
    When User select sorting by "Name"
    Then Workspaces will be sorted alphabetically