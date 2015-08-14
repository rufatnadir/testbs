require 'rspec'
#require 'rubygems'
require_relative '../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../AutomationFrameWork/PageObject/Browser'
#include Test::Unit::Assertions

describe 'Login with correct password' do
  it 'should successfully open user Dashboard Page' do
    Browser.Start
    LogIn.GoTo
    LogIn.EnterUserName('automation.org.user@bluescape.com')
    LogIn.EnterPassword('20sTagi15')
    LogIn.PressSignInButton
    raise 'Did not make it to the Dashboard Page.' unless DashboardPage.CheckIfAtHubPage
  end
end

describe 'Click the Organization link' do
  it 'should successfully open workspaces list page' do
    DashboardPage.SelectOrganizationLink('Enterprise Test')
    raise 'Failed to make it to the organization dashboard.' unless WorkspaceList.CheckIfAtWorkspacesList
  end
end

describe 'Go to workspace Canvas' do
  it 'The workspace canvas page should load successfully' do
    workspace_name = 'NoteCardTest'
    WorkspaceList.GoToWorkspace(workspace_name)
    raise 'The Workspace did not load successfully.' unless Canvas.IsAt(workspace_name)
  end
end


describe 'Look for the note card with text RED NOTE CARD IN CAPS' do
  it 'The previously added note card should be found' do
    #pass the text in the note card to check if this note card exists.
    raise 'could not find the note card' unless Canvas.FindNoteCardOnCanvas('RED NOTE CARD IN CAPS')
  end
end

describe 'double click the note card with the text RED NOTE CARD IN CAPS' do
  it 'note card in edit mode should appear' do
    #pass the text in the note card to check if this note card exists.
    #Brown Note Card or RED NOTE CARD IN CAPS
    Canvas.DoubleClickNoteCard('Brown Note Card')
  end
end

describe 'click Save button for note card in edit mood' do
  it 'note card should be saved with any changes' do
    #pass the text in the note card to check if this note card exists.
    Canvas.NoteCardSaveEdit
  end
end

describe 'Exit workspace' do
  it 'The the workspaces list page should load' do
    Canvas.ExitWorkspace
    raise 'Failed to exit the Canvas to the workspace list page' unless WorkspaceList.CheckIfAtWorkspaceListPage
  end
end

describe 'Click the logout button' do
  it 'User should successfully get logged out' do
    WorkspaceList.SignOut
  end
end
=begin
=end