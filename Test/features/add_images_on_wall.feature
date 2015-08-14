#@dave
#@complete
#@user

Feature: Adding images to the Wall workspace

  Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

  Scenario: Sending the workspace to the Wall
    Given user click create new workspace button
    When user fill the required workspace name as "AddingImagesWallTestToDelete"
    And user click submit
    Then a new workspace should be created "AddingImagesWallTestToDelete"
    When I click on Send to Wall for workspace "AddingImagesWallTestToDelete"
    #And user enters the Wall PIN as "31644"
    And user enters the current PIN of the Wall at "10.7.1.104:1024"
    And user clicks the Send to Wall button
    Then the workspace should load on the Wall
    When I add an image with file name "../../Test/features/images/WallTest1.png" to the Wall at "10.7.1.104:1024"
    Then the image with file name "../../Test/features/images/WallTest1.png" should be in the "staging" database for workspace "AddingImagesWallTestToDelete"
    When I add an image with file name "../../Test/features/images/WallTest2.jpg" to the Wall at "10.7.1.104:1024"
    Then the image with file name "../../Test/features/images/WallTest2.jpg" should be in the "staging" database for workspace "AddingImagesWallTestToDelete"
    
    When User archives the workspace "AddingImagesWallTestToDelete"
    And User perform signout from Bluescape
    Then user should be logged out of his/her account successfully