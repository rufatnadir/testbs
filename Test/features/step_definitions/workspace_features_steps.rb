require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/UsersList_Page'

Given(/^I'm on the "([^"]*)" workspace canvas$/) do |ws_name|
  Canvas.IsAt(ws_name)
end

When(/^I click on Pen icon$/) do
  Canvas.ClickOnPenIcon
end

Then(/^Pen toolbar will open$/) do
  Canvas.CheckIfPenControlsExist
end

And(/^I select "([^"]*)" size for the pen$/) do |pen_size|
  Canvas.SelectPenSize(pen_size)
end

Then(/^"([^"]*)" size for the pen will be selected$/) do |pen_size|
  Canvas.VerifySizeChecked(pen_size)
end

And(/^I select "([^"]*)" color for the pen$/) do |pen_color|
  Canvas.SelectPenColor(pen_color)
end

Then(/^"([^"]*)" color for the pen will be selected$/) do |pen_color|
  Canvas.VerifyColorChecked(pen_color)
end

When(/^I click on Eraser icon$/) do
  Canvas.ClickOnEraser
end

When(/^I set the width of the slider to "([^"]*)"$/) do |value|
  Canvas.SetEraserWidthValue(value)
end

Then(/^Slider value will be set to "([^"]*)"$/) do |arg|
  pending
end

Then(/^The eraser slider will open$/) do |*|
  unless Canvas.CheckIfSliderDisplayed
    raise 'Eraser slider not displayed'
  end
end

When(/^I click on screencast button$/) do
  Canvas.ClickScreenCastButton
end

Then(/^Screencast dialog will open$/) do |*|
  raise 'Screencast dialog not opened' unless SeleniumController.Driver.find_element(:css => '#screenshare > div.panel-header').displayed?
end

And(/^"([^"]*)" button exist$/) do |text|
  raise "'#{text}' button is missing" unless Canvas.CheckStartSharingButton(text)
end

When(/^I click on "([^"]*)" tab$/) do |tab_name|
  Canvas.SwitchToConferenceTab(tab_name)
end

Then(/^"([^"]*)" message displayed$/) do |*, text|
  Canvas.CheckTextOnConference(text)
end

When(/^I click on Share button on "([^"]*)" markers label$/) do |marker_name|
  Canvas.ClickShareOnMarker(marker_name)
end

Then(/^"([^"]*)" dialog will open$/) do |window|
  raise 'Location message window not displayed' unless Canvas.CheckForBroadcastDialog(window)
end

And(/^I enter message "([^"]*)" in text area and send it$/) do |message|
  Canvas.SendBroadcastMessage(message)
end

And(/^There is a message "([^"]*)" from user "([^"]*)"$/) do |message, username|
  raise 'Message not found' unless WorkspaceList.CheckMessageInInbox(message, username)
end

When(/^I click on Enter Workspace button inside the message$/) do
  WorkspaceList.EnterWorkspaceThroughMessage
end

When(/^I click the Selection button on canvas$/) do
  Canvas.ClickGroupSelectionButton
end

Then(/^Group selection modes will display$/) do
  raise 'Group selection Modes not displayed' unless Canvas.CheckIfSelectModes
end

And(/^I select "lasso" mode and select marque mode$/) do
  Canvas.SelectGroupMode
end

When(/^I select "([^"]*)" from message receivers list$/) do |recipient|
  Canvas.SelectMessageRecipientFromList(recipient)
end

Then(/^"([^"]*)" banner wil display on top of the canvas$/) do |message|
  Canvas.VerifyMessageAlertDisplayed(message)
end

And(/^I delete marker "([^"]*)" on canvas$/) do |text|
  Canvas.DeleteLocationMarker(text)
end

And(/^User clicks zoom in button on canvas$/) do
  Canvas.ZoomIn
end

And(/^User removes guest from step above$/) do
  UsersList.RemoveInvitedGuest
end