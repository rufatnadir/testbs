@rufat
@complete
@admin
@ciready
Feature: Change user settings by owner

  Background: Get to users list
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.admin@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    And User click on Users tab

  Scenario: Upgrade guest to user
    When Select "Walter White" from list and click edit button
    And I click on Upgrade Guest to Member button
    Then Member "Walter White" role will be changed to "User"
    And Close screen

  Scenario: Downgrade user to guest
    When Select "Walter White" from list and click edit button
    And I click on Downgrade Member to Guest button
    Then Member "Walter White" role will be changed to "Guest"
    And Close screen

  Scenario: Edit user info(FN, LN, Industry, Phone)
    When Select "Frank Underwood" from list and click edit button
    And I update first name "Saul", last_name "Goodman", industry "Education" and phone_number "7777777777"
    And click save button in the User setting page
    Then Success alert: "Successfully updated" will appear on the page
    When Select "Saul Goodman" from list and click edit button
    When I update first name "Frank", last_name "Underwood", industry "Government" and phone_number "650-999-8877"
    And click save button in the User setting page
    Then Success alert: "Successfully updated" will appear on the page
    And Close screen

  Scenario: Upgrade User to Organization Admin and vise-versa
    When Select "Frank Underwood" from list and click edit button
    And Click on Administrator checkbox
    And click save button in the User setting page
    Then Member "Frank Underwood" role will be changed to "Admin"
    When Select "Frank Underwood" from list and click edit button
    And Click on Administrator checkbox
    And click save button in the User setting page
    Then Member "Frank Underwood" role will be changed to "User"
    And Close screen