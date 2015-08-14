@Sal
@incomplete
@user

Feature: Moving objects on the canvas then asserting the action.

  Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

  Scenario: Going to the workspace on the canvas
    Given I am at the workspaces list
    And Browser resolution is set to 1440 x 900
    And I click on a workspace link "DragAndMovementTest"
    And The workspace "DragAndMovementTest" canvas page should load successfully
    When User moves notecard "Yellow" to location "5480b8b58f7bf378f8000000"


    #And User note down the location of the notecard "I am gonna move this card"
    #When I hold the card "I am gonna move this card" and move it by x:"100" and y:"100"
    #Then Note card "I am gonna move this card" should move to new location by x:"100", y:"100" amount.
    #And I hold the card "I am gonna move this card" and move it by x:"-300" and y:"-300"
    #And Note card "I am gonna move this card" should move to new location by x:"-300", y:"-300" amount.
    #And I hold the card "I am gonna move this card" and move it by x:"200" and y:"200"
    #And Notecard "I am gonna move this card" should be back to the original start location

    And User clicks Exit workspace button on the canvas
    And the workspaces list page should load
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully
