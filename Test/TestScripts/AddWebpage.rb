require 'selenium-webdriver'
require 'rspec'
require 'logger'
require_relative '../../../test_automation/AutomationFrameWork/PageObject/Browser'
require_relative '../../../test_automation/AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../test_automatio/AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../test_automation/AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../test_automation/AutomationFrameWork/PageObject/Dashboard_Page'


file = File.read('../../../test_automation/AutomationFrameWork/config/vars.json')
data_hash = JSON.parse(file)
url = data_hash['portal_url']

Browser.Start
Browser.GoTo url
LogIn.EnterUserName data_hash['owner_email']
LogIn.EnterPassword data_hash['owner_password']
LogIn.PressSignInButton

=begin
DashboardPage.SelectOrganizationLink("TestStage")

WorkspaceList.GoToWorkspace("Load_test_do_not_touch")

browser_widget = SeleniumController.Driver.find_elements(:class, "widget-icon")
@widget_max = 30


begin
Canvas.ClickBrowserButton
Canvas.AddABrowserToCanvas("lenta.ru")
  puts "In - There is a #{browser_widget.count} objects on this workspace"
  browser_widget.count +=1
end while browser_widget.count < @widget_max
    puts "Out - There is a #{browser_widget.count} objects on this workspace"

=end

=begin


webpages = SeleniumController.Driver.find_elements(:class => "gesture-target_web-browser_widget")
i = 0

while webpages.count > i
  webpages[i].click
  SeleniumController.Driver.find_element()
end
=end