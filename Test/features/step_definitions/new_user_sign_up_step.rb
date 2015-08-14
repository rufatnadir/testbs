require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/Signup_Page'

#Trying to sign up with invalid email address and password
Given(/^I'm on the new user sign up page with url "(.*?)"$/) do |page_url|
  Browser.Start
  Browser.GoTo(page_url)
end

When(/^I enter first name "(.*?)"$/) do |first_name|
  SignUp.EnterFirstName(first_name)
end

And(/^I enter last name "(.*?)"$/) do |last_name|
  SignUp.EnterLastName(last_name)
end

And(/^Enter organization name starting with "(.*?)"$/) do |org_name|
  SignUp.EnterRandomOrgName(org_name)
end

And(/^Enter invalid email address "([^"]*)"$/) do |email|
  SignUp.EnterEmail(email)
end

And(/^Enter Password which is too short "([^"]*)"$/) do  |short_pass|
  SignUp.EnterPassword(short_pass)
end

And(/^Select an industry from the drop-down list "(.*?)"$/) do |industry|
  SignUp.SelectIndustry(industry)
end

And(/^Enter phone number "([^"]*)"$/) do |phone|
  SignUp.EnterPhone(phone)
end

And(/^Click on "Start your 14\-day free trial"$/) do
  SignUp.StartFreeTrial
end

Then(/^Alert will be displayed under the "([^"]*)" field "([^"]*)"$/) do |field_name, error|
  raise 'Error message not displayed' unless SignUp.CheckForError(field_name, error)
end

And(/^Enter valid email address starting with "([^"]*)"$/) do |mail|
  SignUp.RandomEmail(mail)
end

And(/^Enter valid Password "([^"]*)"$/) do |password|
  SignUp.EnterPassword(password)
end

Then(/^Greeting will display$/) do
  Browser.CheckIfGreetingDisplay
end

When(/^I click on "([^"]*)" button$/) do |button, *|
  sleep(1)
  Browser.ClickOnButton(button)
end

And(/^Enter organization name "([^"]*)"$/) do |org_name|
  SignUp.EnterOrgName(org_name)
end

#temporarily not in use
When(/^I do not enter first name and last name$/) do
  #pending
end

And(/^Trial banner must be displayed$/) do
  DashboardPage.VerifyTrialBanner
  sleep(2)
end

And(/^Organization list displayed$/) do
  DashboardPage.CheckIfOrgListDisplay
end

When(/^I click on organization name "([^"]*)"$/) do |org_name|
  DashboardPage.SelectOrganizationLink(org_name)
end

When(/^I create (\d+) workspaces starting with name "([^"]*)"$/) do |workspaces_max, workspace_name|
  WorkspaceList.CreateNumberOfWorkspaces(workspaces_max, workspace_name)
end

Then(/^New workspace button must be disabled$/) do
  WorkspaceList.CheckIfButtonDisabled
end

Given(/^I am on the new user Dashboard$/) do
  DashboardPage.VerifyTrialBanner
end

And(/^"([^"]*)" info displayed$/) do |text|
  WorkspaceList.SessionsUsageInfo(text)
end

Then(/^"([^"]*)" window will display$/) do |window_name|
  Browser.CheckIfGreetingDisplay(window_name)
end

Given(/^I'm on the Workspaces page$/) do
  WorkspaceList.CheckIfAtWorkspaceListPage
end