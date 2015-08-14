@rufat
@complete
@user

Feature: Testing User settings from the checklist test cases

  Background: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page

  Scenario Outline: Change FN, LN, Industry, phone
    Given User clicks the user account drop down menu
    And User clicks the user settings button
    And User setting page should load successfully
    When User Updates <first_name>, <last_name>, <industry>, and <phone_number>
    And click save button in the User setting page
    Then The user info should be updated with success message "Your settings have been updated successfully"
    And Update back to original user info:"Organization","User","Financial Services",""
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully
  Examples:
    | first_name        | last_name      | industry       | phone_number          |
    | UpdatedFirstName  | UpdatedLastName| Education      | 7777777777            |

  Scenario: Change user email to already taken
    Given User clicks the user account drop down menu
    And User clicks the user settings button
    And User setting page should load successfully
    When User change email to other existing email like "automation.org.admin@bluescape.com"
    And click save button in the User setting page
    Then Application gives the error message "There was a problem updating your settings"
    And Email "automation.org.user@bluescape.com" is displayed in email text box
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully

  Scenario: Open user Settings
    Given User clicks the user account drop down menu
    When User clicks the user settings button
    Then User setting page should load successfully
    And User perform signout from Bluescape
    And user should be logged out of his/her account successfully

  Scenario Outline: Change user password
    Given User clicks the user account drop down menu
    When User clicks the user settings button
    Then User setting page should load successfully
    When User enters <current_password>, <new_password> and <confirm_new_password>
    And click save button in the User setting page
    Then "Please review the problems below:" error message will display
    When User perform signout from Bluescape
    Then user should be logged out of his/her account successfully
  Examples:
    | current_password |  new_password |  confirm_new_password      |
    | 123456576        |  Nr_3181299   |  Nr_3181299                |
    | 20sTagi15        |  nr3181299    |  nr3181299                 |
    | 20sTagi15        |  Nr_3181299   |  nr3181299                 |

  Scenario: Clean up Case in case "Change FN, LN, Industry, phone" fails
    Given Set User info back to original
