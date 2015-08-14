require 'selenium-webdriver'
require 'rspec'
require 'yaml'
require_relative  '../UtilityClasses/Driver'

class LogIn

  def self.GoTo
    begin
      config = YAML.load_file('../../AutomationFrameWork/config/settings.yml')
      portal_url = config['portal_url']
      SeleniumController.Driver.navigate.to portal_url
    rescue Exception => e
      $log.error "#{e}, Failed to go to logIn Page"
      raise
    end
  end


  #Default enter user name
  def self.EnterUserName
    begin
      user_name = SeleniumController.Driver.find_element(:id, 'user_email')
      config = YAML.load_file('../../AutomationFrameWork/config/settings.yml')
      login_name = config['user_email']
      user_name.send_keys login_name
    rescue Exception => e
      $log.error "#{e}, failed to enter user name name in Login page"
      raise
    end
  end

  #EnterUserName receiving a parameter
  def self.EnterUserName(login_name)
    begin
      user_name = SeleniumController.Driver.find_element(:id, 'user_email')
      user_name.send_keys login_name
    rescue Exception => e
      $log.error "#{e}, failed to enter user name name in Login page"
      raise
    end
  end

  #Default password
  def self.EnterPassword
    begin
      user_password = SeleniumController.Driver.find_element(:id, 'user_password')
      config = YAML.load_file('../../AutomationFrameWork/config/settings.yml')
      pwd = config['user_pass']
      user_password.send_keys pwd
    rescue Exception => e
      $log.error "#{e}, failed to enter user name name in Login page"
      raise
    end
  end

  #paramaterized function
  def self.EnterPassword(pwd)
    begin
      user_password = SeleniumController.Driver.find_element(:id, 'user_password')
      user_password.send_keys pwd
    rescue Exception => e
      $log.error "#{e}, Failed to enter password on Login Page"
      raise
    end
  end

  def self.PressSignInButton
    begin
      signin_button = SeleniumController.Driver.find_element(:css => '#new_user > input.btn.btn-default.btn-primary.btn-login')
      signin_button.click
    rescue Exception => e
      $log.error "#{e}, Failed to press the Sign In button"
      puts 'Sign in failed'
      raise
    end
  end

  def self.InvalidEmailOrPasswordAlert
      alert_message = SeleniumController.Driver.find_element(:class => 'alert-warning')
      if alert_message.displayed?
        puts 'Invalid login message displayed'
        return true
      end
      $log.warn 'invalid password message is not as expected'
  end

  def self.ClickForgotPasswordLink
    begin
      SeleniumController.Driver.find_element(:link_text, 'Forgot your password?').click
    rescue Exception => e
      $log.error "#{e}, possibly couldnt locate the forgot password link"
      raise
    end
  end

  def self.ForgotYourPasswordPage(page_name)
    sleep(2)
    page_header = SeleniumController.Driver.find_element(:css => '#devise-form-container > h2')
    if page_header.text.include? page_name
      puts 'On password retrieval page'
      return true
    end
  end

  def self.ClickSubmitButton
    begin
      SeleniumController.Driver.find_element(:css, '#new_user > input.btn.btn-default.btn-primary.pull-left').click
    rescue Exception => e
      $log.error "#{e}, cant click submit"
      raise
    end
  end

  def self.CheckIfAtChangePasswordPage(text)
    begin
      SeleniumController.Driver.switch_to.window(SeleniumController.Driver.window_handles.last)
      page_title = SeleniumController.Driver.find_element(:css, '#devise-form-container > h2')
      puts page_title.text if
            page_title.text.include? text
      rescue Exception => e
        $log.error "#{e}, couldnt tell if i am at password change page"
        raise 'Not in change password page'
    end
  end

  def self.ClickChangePasswordButton
    begin
      SeleniumController.Driver.find_element(:css, '#new_user > input.btn.btn-default.btn-primary.pull-left').click
    rescue Exception => e
      $log.error "#{e}, failed to click or find the change password button"
      raise
    end
  end
end
