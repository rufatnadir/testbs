@rufat
@complete
@owner
@ciready

Feature: Resetting lost password using email address

  Scenario: Forgot password - send recovery email
  Given I am on the "login" page with "https://staging.portal.bluescape.com" url
  When user click forgot password button
  Then "Forgot your password?" help page will open
  When User enters user email "stagtest@mailinator.com"
  And Click on Submit button
  Then Alert "you will receive a password recovery link at your email address" will appear on the page
  And Close screen

  Scenario: Check email and reset password
  Given I am on the "Mailinator" page with "http://mailinator.com" url
  When I enter user email "stagtest"
  And Click on Check it button
  Then I open an email with subject "Reset password instructions"
  When I click on Reset password link
  Then "Change your password" page will open
  When Enter new password and confirmation "Nr_3181299"
  And Click Change password button
  Then I should be able to login successfully
  And Close screen