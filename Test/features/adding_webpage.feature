@rufat
@incomplete
@user
@ciready

Feature: Adding web page to the workspace

Background: Getting to workspaces list page
  Given I am on the "login" page with "https://staging.portal.bluescape.com" url
  When User enters the user id "automation.org.user@bluescape.com"
  And User enters the password "20sTagi15"
  And User Click Sign In button
  And The user click the Organization link "Enterprise Test"
  Then should successfully open workspaces list page

Scenario: Adding a browser to the workspace
  Given Create workspace "AddingBrowserTestToDelete"
  When I click on a workspace link "AddingBrowserTestToDelete"
  Then The workspace "AddingBrowserTestToDelete" canvas page should load successfully
  And a the page url should carry the workspace id
  When I click add browser button on the canvas
  And I enter the URL "www.google.com" for the website
  And I click the ok button for the browser
  Then A browser element should appear on workspace with link "www.google.com"
  When User clicks Exit workspace button on the canvas
  And User archives the workspace "AddingBrowserTestToDelete"
  And User perform signout from Bluescape
