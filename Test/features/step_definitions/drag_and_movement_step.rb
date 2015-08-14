require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'

When(/^I hold the card "([^"]*)" and move it by x:"([^"]*)" and y:"([^"]*)"$/) do |note_card_text, x_shift, y_shift|
  x_shift.to_i
  y_shift.to_i
  #Getting the card location before making any move
  $x = (Canvas.GiveNoteCardXCoordinates(note_card_text)).to_i
  $y = (Canvas.GiveNoteCardYCoordinates(note_card_text)).to_i
  Canvas.ClickAndHoldNoteCard(note_card_text,x_shift,y_shift)
end

When(/^I move the note card$/) do
  #pending
end

Then(/^The note card should move to a new location$/) do
  #pending
end


Given(/^I am at 50% zoom$/) do
  Canvas.SetZoomTo(50)
end

And(/^Browser resolution is set to (\d+) x (\d+)$/) do |pixel_columns, pixel_rows|
  columns = pixel_columns.to_i
  row = pixel_rows.to_i
  Browser.SetBrowserResolution(columns, row)
end

Then /^wait (\d+) seconds/ do |seconds|
  sleep(seconds.to_i)
end

And(/^User note down the location of the notecard "(.*?)"$/) do |note_card_text|
  $x_start_location = (Canvas.GiveNoteCardXCoordinates(note_card_text)).to_i
  puts $x_start_location
  $y_start_location = (Canvas.GiveNoteCardYCoordinates(note_card_text)).to_i
  puts $y_start_location
end


Then(/^Note card "(.*?)" should move to new location by x:"([^"]*)", y:"([^"]*)" amount\.$/) do |note_card_text ,shift_x, shift_y|
  new_x = (Canvas.GiveNoteCardXCoordinates(note_card_text)).to_i
  new_y = (Canvas.GiveNoteCardYCoordinates(note_card_text)).to_i
  x = new_x - $x
  puts x
  y = new_y - $y
  puts y
  movement_correctness = (x == shift_x.to_i ) && ( y == shift_y.to_i)
  raise 'The shift is not expected' unless movement_correctness
end


Then(/^Notecard "([^"]*)" should be back to the original start location$/) do |note_card_text|
  new_x = (Canvas.GiveNoteCardXCoordinates(note_card_text)).to_i
  new_y = (Canvas.GiveNoteCardYCoordinates(note_card_text)).to_i
  movement_correctness = (new_x == $x_start_location ) && (new_y == $y_start_location)
  raise 'Not In Original Location' unless movement_correctness
end


When(/^User moves notecard "(.*?)" to location "(.*?)"$/) do |notecard_text, location|
  notecards = SeleniumController.Driver.find_elements(:class => 'text-content')
  notecard1 = notecards.keep_if { |notecard|
    notecard.text.include? notecard_text }
  marker = SeleniumController.Driver.find_element(:class => 'location-marker')
  SeleniumController.Driver.action.click_and_hold(notecard1).perform
  sleep(1)
  SeleniumController.Driver.action.move_to(marker).release.perform
end