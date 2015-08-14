require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/PageObject/UserSettings_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'

Given(/^User clicks the user account drop down menu$/) do
  Browser.SelectUserAccountDropDown
end

When(/^User clicks the user settings button$/)  do
  Browser.SelectSettingsButtonInAccountDropDown
end

Then(/^User setting page should load successfully$/) do
  raise 'Did not make it to the User Settings/Edit Page' unless UserSettings.IsAt
end

When(/^User change email to other existing email like "([^"]*)"$/) do |new_email|
  UserSettings.UpdateEmail(new_email)
end

Then(/^Application gives the error message "([^"]*)"$/) do |error_message_text|
  raise 'Cant find the expected error message' unless UserSettings.CheckForErrorMessage(error_message_text)
end

Then(/^Email "([^"]*)" is displayed in email text box$/) do |email_to_check_for|
  raise 'The email you are checking for in text box is not being displayed' unless UserSettings.CheckEmailBoxFor(email_to_check_for)
end

And(/^click save button in the User setting page$/) do
  UserSettings.ClickSaveButton
end

When(/^User Updates (.*), (.*), (.*), and (.*)$/) do |first_name, last_name, industry, phone_number|
  UserSettings.UpdateAccountDetails(first_name, last_name, industry, phone_number)
end

Then(/^The user info should be updated with success message "([^"]*)"$/) do | success_message|
  UserSettings.ConfirmSaveSuccess(success_message)
end

And(/^Update back to original user info:"([^"]*)","([^"]*)","([^"]*)","([^"]*)"$/) do |first_name, last_name, industry, phone|
  UserSettings.UpdateFirstName(first_name)
  UserSettings.UpdateLastName(last_name)
  UserSettings.UpdateIndustry(industry)
  UserSettings.UpdatePhoneNumber(phone)
  UserSettings.ClickSaveButton
end


Given(/^Set User info back to original$/) do |*|
  user_last  = "Organization"
  user_first = "User"
  industry = "Financial Services"
  phone =""
  # Look ma, no quotes!
  # Easier to do "extract steps from plain text" refactorings with cut and paste!
  steps %Q{
      Given User clicks the user account drop down menu
      And User clicks the user settings button
      And Update back to original user info:"#{user_last}","#{user_first}","#{industry}","#{phone}"
      And click save button in the User setting page
      And User perform signout from Bluescape
      And user should be logged out of his/her account successfully
          }
end

When(/^User enters (.*), (.*) and (.*)$/) do |current_password, new_password, confirm_new_password|
  UserSettings.ChangeUserPassword(current_password, new_password, confirm_new_password)
end

Then(/^"([^"]*)" error message will display$/) do |message|
  raise 'Error message not displayed' unless UserSettings.VerifyErrorMessage(message)
end