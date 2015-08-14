require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/Mailinator'


Then(/^user should be logged out of his\/her account successfully$/) do
  #to implement later
end

When(/^User enters the correct the user id (.*) and password (.*)$/) do |user_id, password|
  LogIn.EnterUserName(user_id)
  LogIn.EnterPassword(password)
  LogIn.PressSignInButton
end

And(/^Role should be (.*) in user account pop up$/) do |role|
  DashboardPage.OpenOrgNameDropDown
  raise 'Unexpected Role' unless DashboardPage.ConfirmMemberRole(role)
end

Then(/^I should not be able to login$/) do
  raise 'Can not find the invalid login alert message' unless LogIn.InvalidEmailOrPasswordAlert
end

And (/^Close screen$/) do |*|
  Browser.Stop
  puts 'Quiting the browser'
end

Then(/^(.*) ability to see Organization Settings should be (.*)$/) do |role, organization_settings_accessibility|
  case organization_settings_accessibility
    when 'Account Owner'
      raise role + ' is not able to see Organization Settings' unless Browser.CheckIfThisLinkIsPresentOnPage('Organization Settings')
    when 'Administrator'
      raise role + ' is able to see Organization Settings, he/she should not' unless !(Browser.CheckIfThisLinkIsPresentOnPage('Organization Settings'))
    when 'User'
      raise role + ' is able to see Organization Settings, he/she should not' unless !(Browser.CheckIfThisLinkIsPresentOnPage('Organization Settings'))
  end
end

When(/^user click forgot password button$/) do
  LogIn.ClickForgotPasswordLink
end

Then(/^"([^"]*)" help page will open$/) do |page_title|
  LogIn.ForgotYourPasswordPage(page_title)
end

When(/^User enters user email "([^"]*)"$/) do |user_email|
  LogIn.EnterUserName(user_email)
end

And(/^Click on Submit button$/) do
  LogIn.ClickSubmitButton
end

When(/^I click on Reset password link$/) do
  Mailinator.ClickOnResetLink
end

Then(/^"([^"]*)" page will open$/) do |title|
  LogIn.CheckIfAtChangePasswordPage(title)
end

And(/^Click Change password button$/) do
  LogIn.ClickChangePasswordButton
end

And(/^User perform signout from Bluescape$/) do
  WorkspaceList.SignOut
end