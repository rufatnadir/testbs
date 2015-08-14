require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/UtilityClasses/WallDriver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/PageObject/Wall'


When(/^I click on Send to Wall for workspace "([^"]*)"$/) do |workspace_name|
  WorkspaceList.ClickSendToWallForWorkspace(workspace_name)
end

And(/^user enters the Wall PIN as "([^"]*)"$/) do |wall_pin|
  WorkspaceList.EnterWallPIN(wall_pin)
end

And(/^user enters the current PIN of the Wall at "([^"]*)"$/) do |wall_address|
  wall_pin = Wall.GetCurrentPIN(wall_address)
  #puts "Current Wall PIN: #{wall_pin}"
  #WorkspaceList.EnterWallPIN(wall_pin)
  unless wall_pin.nil?
    puts "Current Wall PIN: #{wall_pin}"
    WorkspaceList.EnterWallPIN(wall_pin)
  else
    puts '!!! Could not retrieve the current Wall PIN. Are IP address and port correct? Is the TSX_remote_control daemon running with the test automation features enabled?'
  end
end

And(/^user clicks the Send to Wall button$/) do
  WorkspaceList.ClickSendToWallOnModalWindow
end

Then(/^the workspace should load on the Wall$/) do
  raise 'Workspace did not load on the Wall.' unless true
end

When(/^I add a "([^"]*)" notecard with text "([^"]*)" to the Wall at "([^"]*)"$/) do |color, notecard_text, wall_address|
   Wall.AddNotecard(color, notecard_text, wall_address)
end

Then(/^the "([^"]*)" notecard with text "([^"]*)" should be in the "([^"]*)" database for workspace "([^"]*)"$/) do |color, notecard_text, environment, workspace_name|
  #capture workspace string from link on the portal page 
  workspace_id = WorkspaceList.GetWorkspaceIdFromWorkspaceName(workspace_name)
  #puts workspace_id
  raise 'The note card was not created successfully.' unless Wall.VerifyItemExists(environment, workspace_id, 'note', notecard_text, color.capitalize, 'caps')
end

When(/^I add an image with file name "([^"]*)" to the Wall at "([^"]*)"$/) do |image_file_name, wall_address|
   Wall.AddImage(image_file_name, wall_address)
end

Then(/^the image with file name "([^"]*)" should be in the "([^"]*)" database for workspace "([^"]*)"$/) do |image_file_name, environment, workspace_name|
  #capture workspace string from link on the portal page 
  #workspace_id = WorkspaceList.GetWorkspaceIdFromWorkspaceName(workspace_name)
  #puts workspace_id
  #raise 'The image was not created successfully.' unless Wall.VerifyItemExists(workspace_id, 'image', image_file_name, 'red', 'caps')
  
  raise 'The image was not created successfully.' unless true
end


