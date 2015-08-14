@rufat
@complete
@user
@ciready
Feature: Create, delete and favorite the workspace

Background: Getting to workspaces list page
  Given I am on the "login" page with "https://staging.portal.bluescape.com" url
  When User enters the user id "automation.org.user@bluescape.com"
  And User enters the password "20sTagi15"
  And User Click Sign In button
  And The user click the Organization link "Enterprise Test"
  Then should successfully open workspaces list page

Scenario: Creating new workspace
  Given user click create new workspace button
  When user fill the required workspace name as "CreateDeleteTestToDelete"
  And user click submit
  Then a new workspace should be created "CreateDeleteTestToDelete"
  When User click star icon in front of the "NoteCardTest"
  And Close screen
  And user should be logged out of his/her account successfully

Scenario: Delete Workspace
  Given User archives the workspace "CreateDeleteTestToDelete"
  Then the "CreateDeleteTestToDelete" should not exists in the workspace list page
  And Workspace "NoteCardTest" marked as favorite
  When User removes favorite star from workspace "NoteCardTest"
  And User perform signout from Bluescape
  Then user should be logged out of his/her account successfully


