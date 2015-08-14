@rufat
@complete
@owner

Feature: Check maximum number of collaborators for trial account
          Maximum 3 collaborators mey be added to the trial account

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

Scenario: Open Users List page
  Given I'm on the Workspaces page
  And Trial banner must be displayed
  When User click on Users tab
  Then should successfully open Users list page

Scenario: Check maximum limit of users to invite
  Given I'm an organization owner on Users list
  When I click on New User button
  And I invite "4" users with random mail "@mailinator.com" to the account
  And Click "Add Users" button
  Then "You only have 3 remaining collaborators available" alert will display
  When I clear emails field
  And I invite "3" users with random mail "@mailinator.com" to the account
  And Click "Add Users" button
  Then "have been emailed invitations" alert info will display
  And Close screen