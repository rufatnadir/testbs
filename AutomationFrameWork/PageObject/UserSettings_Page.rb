require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'

class UserSettings
  def self.IsAt
    return (SeleniumController.Driver.find_element(:id => 'registrations-edit-user'))
  end

  def self.UpdateEmail(new_email_text)
    email_box = SeleniumController.Driver.find_element(:id=> 'user_email')
    email_box.clear
    email_box.send_keys(new_email_text)
  end

  def self.ClickSaveButton
    SeleniumController.Driver.find_element(:css=> "input[name='commit']").click #edit_user > div.form-inputs > input
  end

  def self.CheckForErrorMessage(expected_error_message)
    alert = SeleniumController.Driver.find_element(:class => 'alert-danger').text
    #alert.slice!(0..1)
    return (alert == expected_error_message)
  end

  def self.CheckEmailBoxFor(email_to_check_for)
    email_box = SeleniumController.Driver.find_element(:id=> 'user_email')
    return (email_box.attribute("value") == email_to_check_for)
  end

  def self.UpdateFirstName(new_first_name)
    first_name_box = SeleniumController.Driver.find_element(:id=> 'user_first_name')
    first_name_box.clear
    first_name_box.send_keys(new_first_name)
  end

  def self.UpdateLastName(new_last_name)
    last_name_box = SeleniumController.Driver.find_element(:id=> 'user_last_name')
    last_name_box.clear
    last_name_box.send_keys(new_last_name)
  end

  def self.UpdateIndustry(industry)
    industry_box = SeleniumController.Driver.find_element(:css => "Select[class*='select']")
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

  def self.UpdatePhoneNumber(new_phone_number)
    phone_box = SeleniumController.Driver.find_element(:id => 'user_phone_number')
    phone_box.clear
    phone_box.send_keys(new_phone_number)
  end

  def self.UpdateAccountDetails(first_name, last_name, industry, phone_number)
    self.UpdateFirstName(first_name)
    self.UpdateLastName(last_name)
    self.UpdateIndustry(industry)
    self.UpdatePhoneNumber(phone_number)

  end

  def self.ConfirmSaveSuccess(expected_success_message)
    alert = SeleniumController.Driver.find_element(:css => "div[class*='alert-info']").text
    alert.slice!(0..1)
    return ( alert == expected_success_message )
  end

  def self.EnterCurrentPassword(password)
    current_password_field = SeleniumController.Driver.find_element(:id => 'user_current_password')
    current_password_field.send_keys password
  end

  def self.EnterNewPassword(password)
    new_password_field = SeleniumController.Driver.find_element(:id => 'user_password')
    new_password_field.send_keys password
  end

  def self.ConfirmNewPassword(password)
    confirm_password_field = SeleniumController.Driver.find_element(:id => 'user_password_confirmation')
    confirm_password_field.send_keys password
  end

  def self.ChangeUserPassword(current_password, new_password, confirm_password)
    self.EnterCurrentPassword(current_password)
    self.EnterNewPassword(new_password)
    self.ConfirmNewPassword(confirm_password)
  end

  def self.VerifyErrorMessage(message_text)
    error_message = SeleniumController.Driver.find_element(:class, 'alert-danger')
    if error_message.text == message_text
      return true
    end
  end
end