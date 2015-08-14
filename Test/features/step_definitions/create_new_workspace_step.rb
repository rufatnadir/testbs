require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'

Given(/^I am on the "(.*?)" page with "(.*?)" url$/) do |page_name, page_url|
  Browser.Start
  Browser.GoTo(page_url)
  $test_env = page_url
end

When(/^User enters the correct the userid "([^"]*)" and password "([^"]*)"$/) do |user_id, password|
  LogIn.EnterUserName(user_id)
  LogIn.EnterPassword(password)
  LogIn.PressSignInButton
end


Then(/^I should be able to login successfully$/) do
  raise 'Did not make it to the Dashboard Page.' unless DashboardPage.CheckIfAtHubPage
end

Given(/^The user click the Organization link "([^"]*)"$/) do |org_name|
  DashboardPage.SelectOrganizationLink(org_name)
end

Then(/^should successfully open workspaces list page$/) do
  raise 'Failed to make it to the organization dashboard.' unless WorkspaceList.CheckIfAtWorkspacesList
end

Given(/^user click create new workspace button$/) do
  WorkspaceList.PressNewWorkspaceButton
end

And(/^user fill the required workspace name as "([^"]*)"$/) do |workspace_name|
  WorkspaceList.EnterWorkspaceName(workspace_name)
end

And(/^user click submit$/) do
  WorkspaceList.PressCreateButton
end

Then(/^a new workspace should be created "([^"]*)"$/) do |workspace_name|
  raise 'The workspace was not created successfully.' unless WorkspaceList.WorkspaceInList(workspace_name)
end

Given(/^(?:I am|User) at the workspaces list$/) do
  raise 'Failed to open organization dashboard.' unless WorkspaceList.CheckIfAtWorkspacesList
end

And(/^I click on a workspace link "([^"]*)"$/) do |workspace_name|
  WorkspaceList.GoToWorkspace(workspace_name)
end

Then(/^The workspace "([^"]*)" canvas page should load successfully$/) do |workspace_name|
  Canvas.IsAt(workspace_name)
  Canvas.CloseTour
end

And(/^a the page url should carry the workspace id$/) do
  $workspace_id = Canvas.GetWorkspaceID
end

Given(/^I click on the canvas add note button with text: "([^"]*)", color: "([^"]*)", style: "([^"]*)"$/) do |note_card_text, color, style|
  Canvas.AddANoteCard(note_card_text, color, style)
end

Then(/^the note card with text: "([^"]*)", color: "([^"]*)", style: "([^"]*)" should be created in the "([^"]*)" database$/) do |note_card_text, color, style, environment|
  raise 'The note card was not created successfully.' unless Canvas.VerifyItemExists(environment, 'note', note_card_text, color, style)
end

Given(/^I click add browser button on the canvas$/) do
  Canvas.ClickBrowserButton
end

And(/^I enter the URL "([^"]*)" for the website$/) do |url|
  Canvas.AddABrowserToCanvas(url)
end

And(/^I click the ok button for the browser$/) do
  #need to refactor later
end

Then(/^A browser element should appear on workspace with link "([^"]*)"$/) do |link|
  raise 'Browser not found' unless Canvas.CheckForBrowser(link)
end

Given(/^(?:I click|User clicks) the marker button on the canvas$/) do
  Canvas.AddMarker
end

And(/^Select marker color: "([^"]*)" and gives it title: "([^"]*)"$/) do |marker_color, marker_title|
  Canvas.SetMarkerAttributes(marker_color, marker_title)
end

Then(/^Marker with color "([^"]*)" and text "([^"]*)" should be created in the "([^"]*)" database$/) do |color, title, environment|
  marker_title = title
  marker_color = color
  raise 'The marker was not created successfully.' unless Canvas.VerifyItemExists(environment, 'marker', marker_title, marker_color,nil)
end


Given(/^User clicks Exit workspace button on the canvas$/) do
  Canvas.ExitWorkspace
end

Then(/^the workspaces list page should load$/) do
  raise 'Failed to exit the Canvas to the workspace list page' unless WorkspaceList.CheckIfAtWorkspaceListPage
end

Given(/^User archives the workspace "([^"]*)"$/) do |workspace_name|
  WorkspaceList.ArchiveWorkspaceByName(workspace_name)
end

And(/^removed from the workspaces list$/) do
  #To Implement later
end

When(/^User enters the user id "([^"]*)"$/) do |user_id|
  LogIn.EnterUserName(user_id)
end

And(/^User enters the password "([^"]*)"$/) do |password|
  LogIn.EnterPassword(password)
end

And(/^User Click Sign In button$/) do
  LogIn.PressSignInButton
end

Then(/^the "([^"]*)" should not exists in the workspace list page$/) do |workspace_name|
  raise 'I am still able to see the workspace in the list.' unless !(WorkspaceList.WorkspaceInList(workspace_name))
end

Then(/^The previously saved elements should be found$/) do
  raise 'I was not able to find the note card' unless Canvas.CheckForSavedElements
end

Given(/^workspace "([^"]*)" is created$/) do |workspace_name|

    # Look ma, no quotes!
    # Easier to do "extract steps from plain text" refactorings with cut and paste!
    steps %Q{
      Given user click create new workspace button
      When user fill the required workspace name as "#{workspace_name}"
      And user click submit
      Then a new workspace should be created "#{workspace_name}"
          }
end

When(/^user duplicates workspace "([^"]*)"$/) do |ws_name|
  WorkspaceList.DuplicateWorkspaceByName(ws_name)
end

And(/^Location marker will be displayed on canvas$/) do
  Canvas.CheckForLocationMarker
end

Given(/^User opens settings of workspace "([^"]*)"$/) do |ws_name|
  WorkspaceList.OpenWsSettings(ws_name)
end

When(/^User enters workspace name "([^"]*)"$/) do |ws_new_name|
  WorkspaceList.EnterWorkspaceName(ws_new_name)
end

And(/^User enters workspace description "([^"]*)"$/) do |ws_new_description|
  WorkspaceList.EnterWsDescription(ws_new_description)
end

And(/^Click on Update button on workspace settings$/) do
  WorkspaceList.ClickSaveButton
end

And(/^Workspace "([^"]*)" will appear on list$/) do |workspace_name|
  WorkspaceList.WorkspaceInList(workspace_name)
end

And(/^Create workspace "([^"]*)"$/) do |name|
  WorkspaceList.CreateWorkspace(name)
end

When(/^User click radio button to make workspace available for all org$/) do
  WorkspaceList.MakeWorkspacePublic
end

When(/^User returns to workspaces list$/) do
  WorkspaceList.BackToWorkspacesList
end

Then(/^Sharing status of the "([^"]*)" will be "([^"]*)"$/) do |ws_name, status|
  #raise 'Workspace sharing status incorrect' unless
  WorkspaceList.CheckSharingStatus(ws_name, status)
end

Then(/^The note card with text "([^"]*)" should be created\.$/) do |notecard_text|
  Canvas.FindNoteCardOnCanvas(notecard_text)
end

When(/^User click star icon in front of the "([^"]*)"$/) do |ws_name|
  WorkspaceList.ClickFavoriteStar(ws_name)
end

And(/^Workspace "([^"]*)" marked as favorite$/) do |ws_name|
  WorkspaceList.CheckIfWsinFavorites(ws_name)
end

And(/^User click on archive button$/) do
  WorkspaceList.ClickArchiveWSButton
end

Then(/^Marker with color "([^"]*)" and text "([^"]*)" should be created on the canvas$/) do |color, text|
  raise "Location marker not found" unless Canvas.CheckForLocationMarker
end

When(/^User opens and closes workspace "([^"]*)" (\d+) times$/) do |workspace, count|
  count = count.to_i
  count.times do
    WorkspaceList.GoToWorkspace(workspace)
    Canvas.ExitWorkspace
  end

end

Given(/^User is on not filtered workspaces list$/) do
  WorkspaceList.ReturnWorkspacesOnList
end

When(/^User removes favorite star from workspace "([^"]*)"$/) do |ws_name|
  WorkspaceList.UncheckFavoriteStar(ws_name)
end

When(/^User input text "([^"]*)" on search field$/) do |keyword|
  WorkspaceList.TypeKeywordInSearchField(keyword)
end

Then(/^Only workspaces containing word "([^"]*)" displayed on list$/) do |keyword|
  raise 'List not filtered' unless WorkspaceList.CheckIfSessionsFilteredByKeyword(keyword)
end

When(/^User clears search field$/) do
  WorkspaceList.ClearSearch
  sleep(2)
end

Then(/^All workspaces will be displayed on list$/) do
  raise 'List not cleared' unless WorkspaceList.CheckIfFilterCleared
end

