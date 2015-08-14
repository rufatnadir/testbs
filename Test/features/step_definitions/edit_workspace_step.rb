require 'selenium-webdriver'
require 'cucumber'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'

And(/^User checks the box to make workspace public$/) do
  WorkspaceList.ClickPublicCheckbox
end

And(/^User checks the box to make workspace private$/) do
  WorkspaceList.ClickPrivateCheckbox
end

And(/^Workspace "([^"]*)" update time must be current$/) do |ws_name|
  raise 'Last modified time not updated' unless WorkspaceList.CheckIfTimeUpdated(ws_name)
end

And(/^User select owner of the workspace from list "([^"]*)"$/) do |owner|
  WorkspaceList.ChangeWorkspaceOwner(owner)
end

Then(/^An owner of the workspace "([^"]*)" will be "([^"]*)"$/) do |ws_name, owner|
  raise 'Wrong owner!' unless WorkspaceList.CheckOwnership(ws_name, owner)
end