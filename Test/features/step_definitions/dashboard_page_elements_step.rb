require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'

And(/^I open "Contact Support" form$/) do
  DashboardPage.OpenSupportForm
end

And(/^I click on Help link$/) do
  DashboardPage.ClickHelpLink
end

And(/^I should see Bluescape logo$/) do
  raise 'Bluescape Logo not displayed' unless DashboardPage.CheckBluescapeLogo
end

When(/^I click on upload file button$/) do
  Canvas.UploadFileToCanvas
end


And(/^Highlight "([^"]*)" link$/) do |link_text|
  DashboardPage.Highlight(link_text)
end

Given(/^Click on sorting dropdown for workspaces$/) do
  WorkspaceList.ClickSortingWorkspaces
end

When(/^User select sorting by "([^"]*)"$/) do |entry|
  WorkspaceList.SelectDropdownEntry(entry)
end

Then(/^Workspaces will be sorted alphabetically$/) do
  WorkspaceList.CheckSessionNamesSorting
end

And(/^I select "([^"]*)" from dropdown and type "([^"]*)" and "([^"]*)" in corresponding fields$/) do |subject, field1, field2|
  DashboardPage.SelectSubjectForSupport(subject)
  DashboardPage.FillInSupportFields(field1, field2)
end

And(/^Close support form$/) do
  DashboardPage.CloseSupportForm
end

And(/^Highlight Bluescape Logo$/) do
  DashboardPage.HighlightBluescapeLogo
end