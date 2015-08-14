@rufat
@user
@complete

Feature: Assert items added to canvas are created in the data base

Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

Scenario: Adding a note card and asserting it in the DB
    Given workspace "AddingNoteCardTestToDelete" is created
    And I click on a workspace link "AddingNoteCardTestToDelete"
    And The workspace "AddingNoteCardTestToDelete" canvas page should load successfully
    And a the page url should carry the workspace id
    When I click on the canvas add note button with text: "Lunch today will be Thai", color: "beige", style: "standard"
    Then The note card with text "Lunch today will be Thai" should be created.
    And User clicks Exit workspace button on the canvas
    And User archives the workspace "AddingNoteCardTestToDelete"
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully

Scenario: Adding a browser to the workspace
    Given workspace "AddingBrowserTestToDelete" is created
    And I click on a workspace link "AddingBrowserTestToDelete"
    And The workspace "AddingBrowserTestToDelete" canvas page should load successfully
    When a the page url should carry the workspace id
    And I click add browser button on the canvas
    And I enter the URL "www.google.com" for the website
    And I click the ok button for the browser
    Then A browser element should appear on workspace with link "www.google.com"
    And User clicks Exit workspace button on the canvas
    And User archives the workspace "AddingBrowserTestToDelete"
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully

Scenario: Adding a marker to the canvas
    Given workspace "AddingMarkerTestToDelete" is created
    And I click on a workspace link "AddingMarkerTestToDelete"
    And The workspace "AddingMarkerTestToDelete" canvas page should load successfully
    And a the page url should carry the workspace id
    Given User clicks the marker button on the canvas
    #color allowed values are (blue, red, yellow, green)
    And Select marker color: "blue" and gives it title: "Magic Marker"
    Then Marker with color "blue" and text "Magic Marker" should be created on the canvas
    And User clicks Exit workspace button on the canvas
    And User archives the workspace "AddingMarkerTestToDelete"
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully


