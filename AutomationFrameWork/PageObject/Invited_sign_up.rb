require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'
require_relative '../UtilityClasses/LogsManagement'
require_relative '../../AutomationFrameWork/PageObject/Browser'
#require 'test/unit'

class InvitedSignUp

  def self.CheckIfatSignupPage(text)
    begin
        #handles = SeleniumController.Driver.window_handles

        SeleniumController.Driver.switch_to.window(SeleniumController.Driver.window_handles.last)
        signup_form = SeleniumController.Driver.find_element(:class, 'sign-up-form')
        puts signup_form.text if
            signup_form.text.include? text
      rescue Exception => e
        $log.error "#{e}, failed to find tag line element in signup page"
        raise
      end
  end

  def self.EnterFirstName(first_name)
    begin
      SeleniumController.Driver.find_element(:id, 'user_first_name').send_keys first_name
    rescue Exception => e
      $log.error "#{e}, failed to find the first name field in the signup page"
      raise
    end
  end

  def self.EnterLastName(last_name)
    begin
      SeleniumController.Driver.find_element(:id, 'user_last_name').send_keys last_name
    rescue Exception => e
      $log.error "#{e}, Failed to find the last name field in the signup page"
      raise
    end
  end

  def self.EnterPasswordAndConfirm(password)
    begin
      SeleniumController.Driver.find_element(:id, 'user_password').send_keys password
      SeleniumController.Driver.find_element(:id, 'user_password_confirmation').send_keys password
    rescue Exception => e
      $log.error "#{e}, Upload file to canvas problem"
      raise
    end
  end

  def self.SelectIndustry(industry)
    begin
      industry_box = SeleniumController.Driver.find_element(:css => "#user_industry")
      options = industry_box.find_elements(tag_name: 'option')
  #    exist_in_list = false
      i = 0
      while i < options.count
        if options[i].text == industry
          options[i].click
  #        exist_in_list = true
        end
        i= i+1
      end
#    assert(exist_in_list, 'The industry you provided is not among the option available to select from the drop down list')
    rescue Exception => e
      $log.error "#{e}, Upload file to canvas problem"
      raise
    end
  end

  def self.ClickOnAcceptButton
    begin
      SeleniumController.Driver.find_element(:css, '#edit_user > input.btn.btn-primary').click
    rescue Exception => e
      $log.error "#{e}, Upload file to canvas problem"
      raise
    end
  end
end