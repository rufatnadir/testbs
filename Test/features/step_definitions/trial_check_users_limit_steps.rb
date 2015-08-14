require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/Signup_Page'
require_relative '../../../AutomationFrameWork/PageObject/UsersList_Page'
require_relative '../../../AutomationFrameWork/PageObject/OrgSettings'

And(/^I invite "(\d+)" users with random mail "([^"]*)" to the account$/) do |number_ofusers, email|
  UsersList.EnterNumberOfEmails(number_ofusers, email)
end

Then(/^"([^"]*)" alert will display$/) do |alert_text|
  raise 'Alert not displayed' unless UsersList.CheckAlertDanger(alert_text)
end

Then(/^"([^"]*)" alert info will display$/) do |alert_text|
  raise 'Alert not displayed' unless UsersList.CheckAlertInfo(alert_text)
end

When(/^I clear emails field$/) do
  UsersList.ClearEmailField
end

And(/^"([^"]*)" Benefits are "([^"]*)", "([^"]*)" and "([^"]*)"$/) do |plan, storage_limit, workspaces_limit, users_limit|
  raise 'Plan benefits are incorrect' unless OrgSettings.CheckPlanBenefits(plan, storage_limit, workspaces_limit, users_limit)
end