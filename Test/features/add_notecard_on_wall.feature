#@dave
#@complete
#@user

Feature: Adding notecard to the Wall workspace

  Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

  Scenario: Sending the workspace to the Wall
    Given user click create new workspace button
    When user fill the required workspace name as "AddingNotecardWallTestToDelete"
    And user click submit
    Then a new workspace should be created "AddingNotecardWallTestToDelete"
    When I click on Send to Wall for workspace "AddingNotecardWallTestToDelete"
    #And user enters the Wall PIN as "49236"
    And user enters the current PIN of the Wall at "10.7.1.104:1024"
    And user clicks the Send to Wall button
    Then the workspace should load on the Wall
    When I add a "teal" notecard with text "Teal: template index 0" to the Wall at "10.7.1.104:1024"
    Then the "teal" notecard with text "Teal: template index 0" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    When I add a "beige" notecard with text "Beige: template index 1" to the Wall at "10.7.1.104:1024"
    Then the "beige" notecard with text "Beige: template index 1" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    When I add a "gold" notecard with text "Gold: template index 2" to the Wall at "10.7.1.104:1024"
    Then the "gold" notecard with text "Gold: template index 2" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    When I add a "grey" notecard with text "Grey: template index 3" to the Wall at "10.7.1.104:1024"
    Then the "grey" notecard with text "Grey: template index 3" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    When I add a "red" notecard with text "Red: template index 4" to the Wall at "10.7.1.104:1024"
    Then the "red" notecard with text "Red: template index 4" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    When I add a "yellow" notecard with text "Yellow: template index 5" to the Wall at "10.7.1.104:1024"
    Then the "yellow" notecard with text "Yellow: template index 5" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    When I add a "blue" notecard with text "Blue: template index 6" to the Wall at "10.7.1.104:1024"
    Then the "blue" notecard with text "Blue: template index 6" should be in the "staging" database for workspace "AddingNotecardWallTestToDelete"
    
    When User archives the workspace "AddingNotecardWallTestToDelete"
    And User perform signout from Bluescape
    Then user should be logged out of his/her account successfully