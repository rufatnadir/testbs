@rufat
@complete
@user
@owner
@ciready
Feature: Make workspace public

  Scenario: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"

  Scenario:
    Given I am at the workspaces list
    When user click create new workspace button
    And User enters workspace name "ShareTestToDelete"
    And User enters workspace description "Workspace new"
    And User checks the box to make workspace public
    And user click submit
    Then a new workspace should be created "ShareTestToDelete"
    And Sharing status of the "ShareTestToDelete" will be "organization"

  Scenario: Make workspace private and check last modified time
    Given I am at the workspaces list
    When User click Sharing link of the workspace "ShareTestToDelete"
    And User checks the box to make workspace private
    Then "The workspace was updated successfully" alert info will display
    When User returns to workspaces list
    Then Sharing status of the "ShareTestToDelete" will be "person"
    And Workspace "ShareTestToDelete" update time must be current

  Scenario: Change workspace ownership
    When User opens settings of workspace "ShareTestToDelete"
    And User select owner of the workspace from list "Frank Underwood"
    And Click on Update button on workspace settings
    Then An owner of the workspace "ShareTestToDelete" will be "Frank Underwood"
    And Close screen

  Scenario: Login as new owner and archive workspace
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "test0205@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then User at the workspaces list
    When User archives the workspace "ShareTestToDelete"
    And Close screen



