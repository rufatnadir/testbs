@rufat
@complete
@owner

Feature: Check workspace limit for trial account
  Trial account able to create maximum 3 workspaces
  After that "New workspace button must be disabled"

Scenario: Open trial account
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

Scenario: Check workspaces limit for trial user
  Given I'm on the Workspaces page
  And Trial banner must be displayed
  When I create 3 workspaces starting with name "Test_"
  Then New workspace button must be disabled
  And "3 of 3 Workspaces used" info displayed
  And User perform signout from Bluescape