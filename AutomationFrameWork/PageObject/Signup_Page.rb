require 'selenium-webdriver'
require_relative 'Browser'
require_relative '../UtilityClasses/Driver'

class SignUp

  def self.EnterFirstName(first_name)
    first_name_field = SeleniumController.Driver.find_element(:id => "registration_form_user_first_name")
    first_name_field.send_keys first_name
  end

  def self.EnterLastName(last_name)
    last_name_field = SeleniumController.Driver.find_element(:id => "registration_form_user_last_name")
    last_name_field.send_keys last_name
  end

  def self.EnterRandomOrgName(org_name) # 5 random characters will be added after org_name variable
    org_name_field = SeleniumController.Driver.find_element(:id => "registration_form_organization_name")
    @random = (0...5).map { (65 + rand(26)).chr }.join
    $rand_org_name = org_name + @random
    org_name_field.send_keys $rand_org_name
  end

  def self.EnterOrgName(org_name) #for particular, user defined org name
    org_name_field = SeleniumController.Driver.find_element(:id => "registration_form_organization_name")
    org_name_field.send_keys org_name
  end


  def self.EnterEmail(owner_email)
    email_field = SeleniumController.Driver.find_element(:id => "registration_form_user_email")
    email_field.send_keys owner_email
  end

  def self.RandomEmail(email)
    email_field = SeleniumController.Driver.find_element(:id => "registration_form_user_email")
    email_field.send_keys @random + email
  end

  def self.EnterPassword(password)
    password_field = SeleniumController.Driver.find_element(:id => "registration_form_user_password")
    password_field.send_keys password
  end

  def self.EnterPhone(phone)
    phone_field = SeleniumController.Driver.find_element(:id => "registration_form_user_phone_number")
    phone_field.send_keys phone
  end

  def self.SelectIndustry(industry)
    industry_box = SeleniumController.Driver.find_element(:css => "#registration_form_user_industry")
    options = industry_box.find_elements(tag_name: 'option')
    exist_in_list = false
    i = 0
    while i < options.count
      if options[i].text == industry
        options[i].click
        exist_in_list = true
      end
      i= i+1
    end
    raise 'The industry you provided is not among the option available to select from the drop down list' unless exist_in_list
  end

  def self.StartFreeTrial
    start_button = SeleniumController.Driver.find_element(:css => "#new_registration_form > input.btn.btn-default.btn-primary")
    start_button.click
  end

  def self.CheckForError(field, error_text)
    inline_help = SeleniumController.Driver.find_element(:class => 'registration_form_' + field)
    if inline_help.text == error_text
      puts "Passed: " + field + " " + error_text
      $log.info field + " " + error_text
      else $log.error "Error message not displayed for #{field} field"
    end
  end

end
