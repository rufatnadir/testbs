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
    raise 'Failed to make it to the organization dashboard' unless WorkspaceList.CheckIfAtWorkspacesList
  end
end

describe 'Go to workspace Canvas' do
  it 'The workspace canvas page should load successfully' do
    workspace_name = 'LoadTestWorkspace'
    WorkspaceList.GoToWorkspace('LoadTestWorkspace')
    raise 'The Workspace did not load successfully.' unless Canvas.IsAt(workspace_name)
  end
end


describe 'Look for the elements that were previously saved on the canvas' do
  it 'The previously added note card should be found' do
    raise 'I was not able to find the note card' unless Canvas.CheckForSavedElements
    puts Canvas.CheckForSavedElements
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
