require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/UsersList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Mailinator'
require_relative '../../../AutomationFrameWork/PageObject/Invited_sign_up'

And(/^User click on Users tab$/) do
  WorkspaceList.GoToUsersTab
end

Then(/^should successfully open Users list page$/) do
  raise 'Users List Page not opened' unless UsersList.IsAt
end

Given(/^I'm an organization owner on Users list$/) do
  UsersList.IsAt
end

When(/^I click on New User button$/) do
  UsersList.NewUserInvite
end

Then(/^Browser takes me to "(.*?)" page$/) do |page_title|
  UsersList.AddNewUserPage(page_title)
end

When(/^I enter new user "([^"]*)" on field$/) do |email|
  UsersList.EnterEmail(email)
end

And(/^Click "([^"]*)" button$/) do |*|
  UsersList.AddUserButton
end

Then(/^Alert will be displayed$/) do
  raise 'Alert not displayed' unless UsersList.CheckIfAlert
end

Then(/^I open an email with subject "([^"]*)"$/) do |subject|
  Mailinator.OpenEmailWithSubject(subject)
end

When(/^I click on invitation link$/) do
  Mailinator.ClickOnInvitationLink
end

Given(/^I'm on the Bluescape sign\-up page "([^"]*)"$/) do |text|
  InvitedSignUp.CheckIfatSignupPage(text)
end

When(/^I enter users first name "([^"]*)"$/) do |first_name|
  InvitedSignUp.EnterFirstName(first_name)
end

And(/^I enter users last name "([^"]*)"$/) do |last_name|
  InvitedSignUp.EnterLastName(last_name)
end

And(/^Enter new password and confirmation "([^"]*)"$/) do |password|
  InvitedSignUp.EnterPasswordAndConfirm(password)
end

And(/^Select new industry from the drop\-down list "([^"]*)"$/) do |industry|
  InvitedSignUp.SelectIndustry(industry)
end

And(/^Click Accept invitation button$/) do
  InvitedSignUp.ClickOnAcceptButton
end

Then(/^New tab will open "([^"]*)"$/) do |welcome|
  InvitedSignUp.CheckIfatSignupPage(welcome)
end

And(/^Remove user from organization$/) do
  UsersList.ClickRemoveUserButton
end

When(/^User enters invited user email$/) do
  UsersList.EnterInvitedUserEmail
end

Then(/^User will successfully login to Bluescape$/) do
  DashboardPage.CheckBluescapeLogo
end

And(/^"([^"]*)" message will display$/) do |message|
  raise 'Message not displayed' unless DashboardPage.CheckNoOrgMessage(message)
end