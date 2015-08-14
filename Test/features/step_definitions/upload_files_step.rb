#require 'minitest/autorun'
#require 'minitest/spec'
require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'

Given(/^I'm on the page with url "([^"]*)"$/) do |page_url|
  Browser.Start
  Browser.GoTo(page_url)
  $test_env = page_url
end

When(/^Upload (?:image|file) "(.*)" to the workspace$/) do |filepath|
  Canvas.UploadFileToCanvas(filepath)
end

Then(/^Image will be (?:uploaded|displayed) on canvas$/) do
  raise 'Image not displayed'unless Canvas.CheckForImage
end


Then(/^File will be uploaded to the canvas$/) do
  Canvas.CheckForPDF
end