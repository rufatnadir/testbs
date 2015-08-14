require 'selenium-webdriver'
require 'headless'

class SeleniumController
  instance = SeleniumController.new
  @driver = nil
  @is_active = true
  def self.Start
    @is_active = true
    $log = Logger.new(SeleniumController.GetProjectDirectory + 'test_automation/Test/Logs/LogReport_' + Time.now.strftime("%d_%m_%Y_%H_%M") + '.log')

    case RbConfig::CONFIG['host_os']
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        @driver =Selenium::WebDriver.for :chrome
      when /darwin|mac os/
        @driver =Selenium::WebDriver.for :chrome
      when /linux/
        #we are running this test headlessly in linux. we destroy this headless in kill browser.
        @headless = Headless.new
        @headless.start
        #Selenium::WebDriver::Chrome::Service.executable_path = self.GetProjectDirectory + 'test_automation/Test/chromedriver'
        #remove line above if chromedriver executable installed on TeamCity
        @driver =Selenium::WebDriver.for :chrome


    end

    #puts @driver
    @driver.manage.window.maximize
    case RbConfig::CONFIG['host_os']
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        @driver.manage.timeouts.implicit_wait = 3
      when /darwin|mac os/
        @driver.manage.timeouts.implicit_wait = 3
      when /linux/
        @driver.manage.timeouts.implicit_wait = 15
    end

    self.GetProjectDirectory
  end

  def self.Driver
    return @driver
  end

  def self.KillBrowser
    if @is_active
    @is_active = false
    @driver.quit
    end
  end

  def self.TakeScreenShot(image_path)
    if @is_active
      @driver.save_screenshot(image_path)
      end
  end

  def self.GetProjectDirectory
    driver_directory = File.dirname(__FILE__)
    #puts driver_directory
#50
    driver_directory.slice! 'test_automation/AutomationFrameWork/UtilityClasses'
    #driver_directory = driver_directory[0..-51]
    return driver_directory
  end


  #wait helper method, this will introduce a hybrid of implicit and explicit wait,
  #we pass the actually web element and the max time out,
  #once you call this method, the system will search for the element, wait and second
  #then search again, it will continue repeating until element is found or the max
  # number of attempts (time_out) is reached, then it will stop and return false.
  #once element is found before timeout, it will return true.
  def self.WaitUntilElementIsPresent(web_element, time_out)
    i = 0
    until i == time_out do
      if self.Driver.find_elements(:class => web_element).size > 0
        puts true
        return true
      end
      sleep(3)
      i +=1
    end
    return false
  end

  def self.WaitForElement(seconds)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until {yield}
  end
end
