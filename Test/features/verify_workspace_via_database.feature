Feature: Loading a saved workspace and finding a specific note card using its text then opening it in Edit mode.

Background: Getting to workspaces list page
   Given I am on the "login" page with "https://staging.portal.bluescape.com" url
   When User enters the user id "automation.org.user@bluescape.com"
   And User enters the password "20sTagi15"
   And User Click Sign In button
   And The user click the Organization link "Enterprise Test"
   Then should successfully open workspaces list page
   
 Scenario: Create a new workspace for this test
   Given user click create new workspace button
   When user fill the required workspace name as "VerifyCanvasTestToDelete"
   And user click submit
   Then a new workspace should be created "VerifyCanvasTestToDelete"
   Given I am at the workspaces list
   When I click on a workspace link "VerifyCanvasTestToDelete"
   Then The workspace "VerifyCanvasTestToDelete" canvas page should load successfully 
   When I click on the canvas add note button with text: "Bluescape1", color: "blue", style: "standard"
   Then the note card with text: "Bluescape1", color: "blue", style: "standard" should be created in the "staging" database
   When I click on the canvas add note button with text: "Bluescape2", color: "beige", style: "header"
   Then the note card with text: "Bluescape2", color: "beige", style: "header" should be created in the "staging" database
 
 
   When User clicks Exit workspace button on the canvas
   And the workspaces list page should load
   When User archives the workspace "VerifyCanvasTestToDelete"
   And User perform signout from Bluescape
   Then user should be logged out of his/her account successfully