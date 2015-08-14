@rufat
@complete
@owner
@test
@ciready

Feature: Upgrade trial account to paid

Scenario: Trial account creation
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


Scenario: Upgrade to professional plan
  Given I am at the workspaces list
  And I verify icons images exist for class "send-message-hint-icon"
  When I click on organization settings
  And I click on Upgrade to paid plan button
  When I verify icons images exist for class "card-icons"
  And I select "professional" plan
  Then Plan upgrade page with header "Select your Bluescape plan" displayed
  And Total plan cost "$79.99" will display
  When I enter card number "4012888888881881"
  And I enter expiration dates "07", "2016", security code "881"
  And I enter billing info "First" "Last" "999 Skyway rd" "Denver"
  And Select state "Colorado" from list and enter zip code "94042"
  And Click Purchase plan button
  Then Alert "Successfully changed to professional plan" will appear on the page
  And Close screen
