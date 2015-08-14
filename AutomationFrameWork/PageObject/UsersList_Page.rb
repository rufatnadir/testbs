require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'
require_relative '../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../PageObject/Mailinator'
#require 'test/unit'

class UsersList

  @wait = Selenium::WebDriver::Wait.new(:timeout => 20)

  def self.IsAt
    return SeleniumController.Driver.find_element(:class => "table-header").displayed?
  end

  def self.NewUserInvite
    SeleniumController.Driver.find_element(:class => 'new-member').click
  end

  def self.AddNewUserPage(page_title)
    SeleniumController.Driver.find_element(:tag_name => 'h2').text == page_title
  end

  def self.EnterEmail(email)
    $rand_mail = (0...5).map { (65 + rand(26)).chr }.join + email
    SeleniumController.Driver.find_element(:css => "#bulk_add_users_form_emails").send_keys $rand_mail + ", "
  end

  def self.EnterNumberOfEmails(number, email)
    $rand_mail = (0...5).map { (65 + rand(26)).chr }.join + email
    number = number.to_i
    number.times do
      EnterEmail(email)
    end
  end

  def self.AddUserButton
    SeleniumController.Driver.find_element(:css => '#new_bulk_add_users_form > div.btn-submit-cancel-options > input').click
  end

  def self.CheckIfAlert
    SeleniumController.Driver.find_element(:class => 'alert-info').displayed?
  end

  def self.CheckAlert(text)
    alert = SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.container > div:nth-child(2) > div')
    #puts alert.text
      if alert.text.include? text
        puts "Alert displayed: '#{alert.text}'"
        return true
      else puts 'Alert not displayed'
    end
  end

  def self.CheckAlertInfo(text)
    alerts = SeleniumController.Driver.find_elements(:class => 'alert-info')
    #puts alert.text
    alerts.keep_if { |alert| alert.text.include? text }
    if alerts.count > 0
      puts "Alert displayed: '#{alerts[0].text}'"
      return true
    end
  end

  def self.CheckAlertDanger(text)
    alert = SeleniumController.Driver.find_element(:class => 'alert-danger')
    if alert.text.include? text
      puts "Alert displayed: #{alert.text}"
      return true
    end
  end

  def self.ClearEmailField
    SeleniumController.Driver.find_element(:css => "#bulk_add_users_form_emails").clear
  end

#  def self.CheckMail
#    SeleniumController.Driver.find_element(:css => "#inboxfield").send_keys @rand_mail
#  end

  def self.ClickButton(button_name)
    button = SeleniumController.Driver.find_element(:link_text, "#{button_name}")
    button.click
    sleep(3)
  end

  def self.RemovePendingGuests
    sleep(2)
    invited_guests = SeleniumController.Driver.find_elements(:class => 'list-item')
    invited_guests.keep_if { |guest|
      guest.text.include? $email }
      invited_guests[0].find_element(:class => 'member-edit').click
    SeleniumController.Driver.find_element(:class => 'trash').click
      sleep(1)
      SeleniumController.Driver.switch_to.alert.accept
    puts 'Rejecting guest by admin'
        sleep(2)
  end


  def self.RemoveInvitedGuest
    invited_guests = SeleniumController.Driver.find_elements(:css => 'muted-row')
    invited_guests.keep_if { |guest|
       guest.text.include? $email
                          }
    #puts invited_guests[0].text
    invited_guests[0].find_element(:class => 'member-edit').click
    @wait.until {SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.row > div.col-xs-5.edit-user-form > h2').displayed? }
    SeleniumController.Driver.find_element(:class => 'trash').click
    SeleniumController.Driver.switch_to.alert.accept
    sleep(2)
  end

  def self.AcceptInvitedGuest
    sleep(2)
    invited_guests = SeleniumController.Driver.find_elements(:class => 'list-item')
    invited_guests.keep_if { |guest|
      guest.text.include? $email
    }
    raise 'Guest not in list' unless invited_guests.count > 0
    invited_guests[0].find_element(:link_text => 'Accept Guest').click
    puts 'Accepting guest by admin'
    sleep(2)
  end

  def self.EnterInvitedUserEmail
    SeleniumController.Driver.find_element(:id, 'user_email').send_keys $rand_mail
  end

  def self.ClickRemoveUserButton
    SeleniumController.Driver.find_element(:link_text => 'Remove User').click
    SeleniumController.Driver.switch_to.alert.accept
  end

end

