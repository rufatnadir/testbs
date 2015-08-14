require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'

Given(/^User is logged into the canvas "([^"]*)"$/) do |workspace_name|
#  WorkspaceList.GoToWorkspace(workspace_name)
  raise 'The Workspace did not load successfully.' unless Canvas.IsAt(workspace_name)
end

Then(/^Note card with text "([^"]*)" should be present$/) do |note_card_text|
  sleep(2)
  raise 'Failed to find note card' unless Canvas.FindNoteCardOnCanvas(note_card_text)
end

Given(/^User double click on the note card with text "([^"]*)"$/) do |note_card_text|
  Canvas.DoubleClickNoteCard(note_card_text)
end

Then(/^Note card should open in Edit mode$/) do
    #implemented in the step above, to fix refactor later
end

When(/^User clicks the Save button for note card in edit mode$/) do
  Canvas.NoteCardSaveEdit
end

Then(/^Current status or changes of the note card should be saved$/) do
  #not confirm yet, to revisit later.
end

And(/^Note card with text "([^"]*)" and color "([^"]*)" should be present on canvas$/) do |text, color|
  Canvas.FindNoteCardOnCanvas(text, )
  #raise 'The note card not exist.' unless Canvas.VerifyItemExists('note', text, color, 'caps')
end

And(/^User change notecard color to "([^"]*)"$/) do |color|
  Canvas.ChangeNotecardColor(color)
end

And(/^User change notecard text to "([^"]*)"$/) do |text|
  Canvas.ChangeNotecardText(text)
end