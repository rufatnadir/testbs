@rufat
@complete
@user

  Feature: Create new workspace and duplicate it

    Background: Getting to workspaces list page
      Given I am on the "login" page with "https://staging.portal.bluescape.com" url
      When User enters the user id "automation.org.user@bluescape.com"
      And User enters the password "20sTagi15"
      And User Click Sign In button
      And The user click the Organization link "Enterprise Test"
      And Highlight "Users" link
      Then should successfully open workspaces list page

    Scenario: Creating new workspace with elements
      Given Create workspace "TestWorkspace"
      Then a new workspace should be created "TestWorkspace"
      And I click on a workspace link "TestWorkspace"
      Then The workspace "TestWorkspace" canvas page should load successfully
      When I click on the canvas add note button with text: "Notecard duplicate", color: "red", style: "header"
      And I click add browser button on the canvas
      And I enter the URL "www.youtube.com" for the website
      And I click the ok button for the browser
      When I click the marker button on the canvas
      #color allowed values are (blue, red, yellow, green)
      And Select marker color: "green" and gives it title: "Marker Duplicated"
      Then Marker with color "green" and text "Marker Duplicated" should be created on the canvas
      And User clicks Exit workspace button on the canvas
      And User opens settings of workspace "TestWorkspace"
      When user duplicates workspace "TestWorkspace"
      And User click on archive button
      Then a new workspace should be created "DuplicateWS"
      And Close screen

    Scenario: Verify items in duplicated workspace
      When I click on a workspace link "DuplicateWS"
      Then The workspace "DuplicateWS" canvas page should load successfully
      And a the page url should carry the workspace id
      And A browser element should appear on workspace with link "www.youtube.com"
      And Marker with color "green" and text "Marker Duplicated" should be created on the canvas
      And Note card with text "Notecard duplicate" and color "red" should be present on canvas
      And Close screen


    Scenario: Edit workspace name
      Given User opens settings of workspace "DuplicateWS"
      When User enters workspace name "New Workspace"
      And User enters workspace description "New description"
      And Click on Update button on workspace settings
      Then "The workspace was updated successfully" alert info will display
      And Workspace "New Workspace" will appear on list
      And User archives the workspace "New Workspace"
      And Close screen

