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

describe 'Create new workspace and fill the needed info' do
  it 'should create new workspace' do
    WorkspaceList.PressNewWorkspaceButton
    workspace_name= 'AutomatedWorkSpaceDL'
    WorkspaceList.EnterRandomWorkspaceName(workspace_name)
    WorkspaceList.PressCreateButton
    raise 'The workspace was not created successfully.' unless WorkspaceList.WorkspaceInList(workspace_name)
  end
end

describe 'Go to workspace Canvas' do
  it 'The workspace canvas page should load successfully' do
    workspace_name = 'AutomatedWorkSpaceDL'
    WorkspaceList.GoToWorkspace(workspace_name)
    raise 'The Workspace did not load successfully.' unless Canvas.IsAt(workspace_name)
    $workspace_id = Canvas.GetWorkspaceID
  end
end

describe 'Add a note card to the Canvas' do
  it 'The note card should be created in the workspace successfully' do
    #colors allowed are (teal, beige, gold, grey, red, blue, yellow )
    #style allowed values are (standard, header)
    Canvas.AddANoteCard('Lunch today will be Thai', 'red', 'standard' )
    raise 'The note card was not created successfully.' unless Canvas.VerifyItem('note', 'Lunch today will be Thai', 'red', 'caps')
  end
end

describe 'Add a browser to the workspace' do
  it 'The browser should be loaded on the workspace with the intended link' do
    browser_link = 'www.google.com'
    Canvas.AddABrowserToCanvas(browser_link)
    raise 'The browser was not created successfully.' unless Canvas.VerifyItem('webbrowser', browser_link,nil,nil)
  end
end

describe 'Add a marker to the Canvas' do
  it 'The marker should be added to the canvas' do
    marker_title = 'Magic Marker'
    marker_color = 'yellow'
    Canvas.AddMarker
    Canvas.SetMarkerAttributes(marker_color, marker_title)
    raise 'The marker was not created successfully.' unless Canvas.VerifyItem('marker', marker_title, marker_color,nil)
  end
end

describe 'Exit workspace' do
  it 'The the workspaces list page should load' do
    Canvas.ExitWorkspace
    raise 'Failed to exit the Canvas to the workspace list page' unless WorkspaceList.CheckIfAtWorkspaceListPage
  end
end


describe 'Archive the newly created workspace' do
  it 'It should be taken out of the workspaces list' do
    WorkspaceList.ArchiveWorkspaceByID($workspace_id)
  end
end

describe 'Click the logout button' do
  it 'User should successfully get logged out' do
    WorkspaceList.SignOut

  end
end

