require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/Mailinator'
require_relative '../../../AutomationFrameWork/PageObject/UsersList_Page'

Given(/^Navigate to "([^"]*)"$/) do |url|
  Browser.GoTo(url)
end

Then(/^should successfully open workspace "([^"]*)" page$/) do |page_header|
  raise 'Sharing screen not opened' unless WorkspaceList.CheckIfAtSharingScreen(page_header)
end

Given(/^I'm on the "([^"]*)" page$/) do |page_header|
  #raise 'Sharing screen not opened' unless
  WorkspaceList.CheckIfAtSharingScreen(page_header)
end

When(/^I'm entering guests email "([^"]*)" on email field$/) do |guest_email|
  WorkspaceList.EnterGuestEmail(guest_email)
end

And(/^Click on Share button$/) do
  WorkspaceList.ClickAddGuestButton
end

Then(/^"([^"]*)" alert appears on top of the page$/) do |alert_text|
  raise 'Alert not displayed' unless UsersList.CheckAlertInfo(alert_text)
end

Given(/^I'm on the mailinator home page "([^"]*)"$/) do |page_url|
  Browser.Start
  Browser.GoTo(page_url)
end

Then(/^There is an email with subject "([^"]*)"$/) do |subject|
  sleep(2)
  raise 'Email not delivered' unless Mailinator.CheckEmailSubject(subject)
end

And(/^Click on Check it button$/) do
  Mailinator.CheckInbox
end

And(/^User click Sharing link of the workspace "([^"]*)"$/) do |workspace_name|
  WorkspaceList.OpenShareScreen(workspace_name)
end

When(/^I enter guest email from step above$/) do
  Mailinator.EnterGuestEmail
end

When(/^I enter user email from step above$/) do
  Mailinator.EnterPredefinedEmail
end

When(/^I enter user email "([^"]*)"$/) do |email|
  Mailinator.EnterMailToCheck(email)
end

And(/^I click on "([^"]*)" link$/) do |link_text|
  Mailinator.ClickOnLink(link_text)
end

Then(/^"([^"]*)" page will open on new tab$/) do |page_name|
  DashboardPage.CheckIfAtSignInPage(page_name)
end

And(/^Click on "([^"]*)" button$/) do |button|
  UsersList.ClickButton(button)
end

And(/^User removes all pending guests$/) do
  UsersList.RemovePendingGuests
end

Then(/^Guest email is empty$/) do
  Mailinator.VerifyEmptyInbox
end

And(/^User removes pending guest from step above$/) do
  UsersList.RemovePendingGuests
end

And(/^User accept pending guest from step above$/) do
  UsersList.AcceptInvitedGuest
end

And(/^I click on Close tour button$/) do
  Canvas.CloseTour
end