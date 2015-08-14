require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'

class Browser
  def self.Start
    SeleniumController.Start
  end

  def self.GoTo(page_url)
    SeleniumController.Driver.navigate.to(page_url)
  end

  def self.Stop
    SeleniumController.KillBrowser
  end

  def self.CaptureScreen(path)
    SeleniumController.TakeScreenShot(path)
    return 'Screen shot of failed assert is stored in CapturedImages'
  end

  def self.GetProjectPath
    return SeleniumController.GetProjectDirectory
  end

  def self.SetBrowserResolution(pixel_columns, pixel_rows)
    target_size = Selenium::WebDriver::Dimension.new(pixel_columns, pixel_rows)
    SeleniumController.Driver.manage.window.size = target_size
  end

  def self.CheckIfThisLinkIsPresentOnPage(text_of_link)
    return SeleniumController.Driver.find_element(:link_text => text_of_link).displayed?
  end

  def self.SelectUserAccountDropDown
    drop_down = SeleniumController.Driver.find_element(:class => 'user-settings')
    raise 'drop down menu can not be found' unless SeleniumController.WaitUntilElementIsPresent('user-settings', 10 )
    drop_down.click if drop_down.displayed?
  end

  def self.FindElementByClass(class_name)
    SeleniumController.Driver.find_element(:class => class_name)
  end

  def self.CheckIfGreetingDisplay(window_name)
    modal_window = SeleniumController.Driver.find_element(:class => 'modal-content')
    return true if modal_window.text == window_name
    puts "#{window_name} window displayed"
  end

  def self.ClickOnButton(button)
   button = SeleniumController.Driver.find_element(:link_text => button)
   rescue
      puts 'Button not exist'
   else
      button.click
  end

  def self.SelectSettingsButtonInAccountDropDown
    SeleniumController.Driver.find_element(:class => 'user-settings-cog').click
  end

  def self.CleanUpAfterFail
    self.Stop
  end

  def self.WriteToTheLogFileInfo(text_to_log)
    $log.info text_to_log + Time.now.strftime("%d/%m/%Y Time:%H:%M:%S")
  end

  def self.ChangeUrl(target, value)
    current_url = SeleniumController.Driver.current_url
    $sub_url = current_url.gsub!(target, value)
    return $sub_url
  end
end


