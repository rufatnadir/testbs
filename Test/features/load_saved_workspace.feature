@rufat
@incomplete
@user
@ciready

Feature: Loading a saved workspace and confirming all previously saved elements are loading correctly
  Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

  Scenario: Going to the workspace on the canvas and confirm previously saved loaded successfully
    Given I am at the workspaces list
    When I click on a workspace link "LoadTestWorkspace"
    Then The workspace "LoadTestWorkspace" canvas page should load successfully
    And Note card with text "Test Notecard" should be present
    And A browser element should appear on workspace with link "cnn.com"
    And Image will be displayed on canvas
    And Location marker will be displayed on canvas
    And User clicks zoom in button on canvas
    And User clicks Exit workspace button on the canvas
    And the workspaces list page should load
    Given User perform signout from Bluescape
    Then user should be logged out of his/her account successfully
