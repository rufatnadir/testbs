@rufat
@complete
@owner
@test
@ciready

Feature: New user sign up to Bluescape

  Scenario: New account creation, invalid email and password
    Given I'm on the new user sign up page with url "https://staging.portal.bluescape.com/users/sign_up"
    When I enter first name "UserFirst"
    And I enter last name "UserLast"
    And Enter organization name "Bluescape"
    And Enter invalid email address "abc.com"
    And Enter Password which is too short "12345"
    And Select an industry from the drop-down list "Education"
    And Enter phone number "123456"
    And Click on "Start your 14-day free trial"
    Then Alert will be displayed under the "user_password" field "is too short  (minimum is 8 characters)"
    And Alert will be displayed under the "user_email" field "is invalid"
    And Alert will be displayed under the "organization_name" field "has already been taken"
    And Close screen

  Scenario: New account creation
    Given I'm on the new user sign up page with url "https://staging.portal.bluescape.com/users/sign_up"
    When I enter first name "UserFirst"
    And I enter last name "UserLast"
    And Enter organization name starting with "Organization_"
    And Enter valid email address starting with "owner@mailinator.com"
    And Enter valid Password "Nr_3181299"
    And Select an industry from the drop-down list "Real Estate"
    And Enter phone number "1234567"
    And Click on "Start your 14-day free trial"
    Then "Using Bluescape" window will display
    When I click on "Get Started" button
    And I click on "Next" button
    And I click on "Next" button
    And I click on "Finished" button
    Then I should be able to login successfully
    And Trial banner must be displayed
    And Close screen