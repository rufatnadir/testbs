require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/UsersList_Page'
require_relative '../../../AutomationFrameWork/PageObject/OrgSettings'
require_relative '../../../AutomationFrameWork/PageObject/UserSettings_Page'

When(/^I click on organization settings$/) do
  OrgSettings.OpenOrganizationSettings
end

And(/^I click on Upgrade to paid plan button$/) do
  OrgSettings.ClickUpgradePlan
end

Then(/^Plan upgrade page with header "([^"]*)" displayed$/) do |header|
  OrgSettings.CheckIfAtUpgradePage(header)
end

When(/^I select "([^"]*)" plan$/) do |plan|
  OrgSettings.SelectPlan(plan)
  sleep(2)
end

Then(/^Total plan cost "(\$\d+\.\d+)" will display$/) do |cost|
  OrgSettings.CheckPrice(cost)
end

When(/^I enter card number "([^"]*)"$/) do |card_number|
  OrgSettings.EnterCardNumber(card_number)
end

And(/^I enter expiration dates "([^"]*)", "([^"]*)", security code "([^"]*)"$/) do |date1, date2, sec_code|
  OrgSettings.EnterCardDatesAndCode(date1, date2, sec_code)
end

And(/^I enter billing info "([^"]*)" "([^"]*)" "([^"]*)" "([^"]*)"$/) do |first_name, last_name, street, city|
  OrgSettings.EnterCredentials(first_name, last_name, street, city)
end

And(/^Select state "([^"]*)" from list and enter zip code "([^"]*)"$/) do |state, zipcode|
  OrgSettings.EnterStateAndZip(state, zipcode)
end

And(/^Click Purchase plan button$/) do
  OrgSettings.ClickPurchasePlan
end

Then(/^Alert "([^"]*)" will appear on the page$/) do |alert|
  raise 'Test Failed, alert is wrong' unless OrgSettings.CheckAlertNotice(alert)
end

And(/^Select checkbox "([^"]*)"$/) do |checkbox_name|
  OrgSettings.SelectAdminApproveCheckBox(checkbox_name)
  sleep(2)
end


And(/^Select "([^"]*)" from list and click edit button$/) do |user_name|
  OrgSettings.OpenUserSettings(user_name)
end

When(/^I click on Upgrade Guest to Member button$/) do
  OrgSettings.ClickOnUpgradeLink
end

Then(/^User setting page will open$/) do
  #pending
end

When(/^I click on Downgrade Member to Guest button$/) do
  OrgSettings.ClickOnDowngradeLink
end

And(/^I update first name "([^"]*)", last_name "([^"]*)", industry "([^"]*)" and phone_number "([^"]*)"$/) do |first_name, last_name, industry, phone|
  OrgSettings.ChangeUserFirstName(first_name)
  OrgSettings.ChangeUserLastName(last_name)
  UserSettings.UpdateIndustry(industry)
  OrgSettings.ChangeUserPhone(phone)
end

Then(/^Success alert: "([^"]*)" will appear on the page$/) do |alert_text|
  OrgSettings.CheckSuccessAlert(alert_text)
end

Then(/^Member "([^"]*)" role will be changed to "([^"]*)"$/) do |mem_name, mem_role|
  OrgSettings.CheckMemberRole(mem_name, mem_role)
end

And(/^Click on Administrator checkbox$/) do
  OrgSettings.ClickAdminCheckBox
end

And(/^Unselect checkbox "([^"]*)"$/) do |checkbox|
  OrgSettings.UnselectAdminApprovalCheckbox
  sleep(3)
end

And(/^User substitutes on url "([^"]*)" to "([^"]*)" and opens it$/) do |target, value|
  Browser.ChangeUrl(target, value)
  Browser.GoTo($sub_url)
end

When(/^I verify icons images exist for class "([^"]*)"$/) do |class_name|
  OrgSettings.CheckImageIcons(class_name)
end