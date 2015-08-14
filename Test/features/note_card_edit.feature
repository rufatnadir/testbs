@rufat
@incomplete
@user

Feature: Loading a saved workspace and finding a specific note card using its text then opening it in Edit mode.

Background: Getting to workspaces list page
   Given I am on the "login" page with "https://staging.portal.bluescape.com" url
   When User enters the user id "automation.org.user@bluescape.com"
   And User enters the password "20sTagi15"
   And User Click Sign In button
   And The user click the Organization link "Enterprise Test"
   Then should successfully open workspaces list page

Scenario: Going to the workspace on the canvas and editing an existing notecard
  Given I click on a workspace link "NoteCardTest"
  And The workspace "NoteCardTest" canvas page should load successfully
  And Note card with text "RED NOTE CARD IN CAPS" should be present
  And Note card with text "Brown Note Card" should be present
  When User double click on the note card with text "Brown Note Card"
  Then Note card should open in Edit mode
  And User change notecard color to "yellow"
  And User change notecard text to "Yellow Note Card"
  And User clicks the Save button for note card in edit mode
  And Current status or changes of the note card should be saved
  And User clicks Exit workspace button on the canvas
  #And User clicks the logout button
  And Close screen

Scenario: Change notecard details back to defaults
  Given I click on a workspace link "NoteCardTest"
  When User double click on the note card with text "Yellow Note Card"
  Then Note card should open in Edit mode
  When User change notecard color to "beige"
  And User change notecard text to "Brown Note Card"
  And User clicks the Save button for note card in edit mode
  Then Current status or changes of the note card should be saved
  And User clicks Exit workspace button on the canvas
  And the workspaces list page should load
  And User perform signout from Bluescape
  And user should be logged out of his/her account successfully
