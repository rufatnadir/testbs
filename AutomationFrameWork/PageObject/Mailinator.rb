require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'
require_relative '../PageObject/WorkspacesList_Page'
require_relative '../PageObject/UsersList_Page'

class Mailinator

  def self.EnterMailToCheck(email)
    inbox_field = SeleniumController.Driver.find_element(:css => '#inboxfield')
    inbox_field.send_keys email
  end

  def self.EnterGuestEmail
    inbox_field = SeleniumController.Driver.find_element(:css => '#inboxfield')
    inbox_field.send_keys $email
  end

  def self.EnterPredefinedEmail
    inbox_field = SeleniumController.Driver.find_element(:css => '#inboxfield')
    inbox_field.send_keys $rand_mail
    puts 'Predefined email is: ' + $rand_mail
  end

  def self.CheckInbox

    SeleniumController.Driver.find_element(:class => 'btn-success').click
  end

  def self.CheckEmailSubject(subject)
    email_sublect = SeleniumController.Driver.find_element(:css => '#mailcontainer > li:nth-child(1) > a > div.subject.ng-binding')
    puts email_sublect.text
    if email_sublect.text.include? subject
      puts 'Passed: Email delivered'
      return true
    end
  end

  def self.OpenEmailWithSubject(subject)
    email_subject = SeleniumController.Driver.find_element(:css => '#mailcontainer > li > a > div.subject.ng-binding')
    if email_subject.text == subject
      email_subject.click
    else
      puts 'Email not found'
    end
  end

  def self.ClickOnInvitationLink

    # the email body is rendered inside an iframe, so there may be a short delay before selenium can see the iframe's contents
    sleep(2)

    SeleniumController.Driver.switch_to.frame('rendermail')
    acceptance_link = SeleniumController.Driver.find_element(:css => '#templatebody > tbody > tr > td > table > tbody > tr > td > table > tbody > tr > td > a')
    if acceptance_link.text == 'Accept Invitation'
      acceptance_link.click
    else
      puts 'Invitation link not found'
    end
  end

  def self.VerifyEmptyInbox
    SeleniumController.Driver.find_element(:id => 'noemailmsg').displayed?
    puts "Guest inbox is empty"
  end


  def self.ClickOnResetLink

    # the email body is rendered inside an iframe, so there may be a short delay before selenium can see the iframe's contents
    sleep(1)

    SeleniumController.Driver.switch_to.frame('rendermail')
    SeleniumController.Driver.find_element(:link_text, 'Reset your password').click
    #if acceptance_link.text == 'Accept Invitation'
    #  acceptance_link.click
    #else
    #  puts 'Invitation link not found'
  end

  def self.ClickOnLink(link_text)

    # the email body is rendered inside an iframe, so there may be a short delay before selenium can see the iframe's contents
    sleep(1)

    SeleniumController.Driver.switch_to.frame('rendermail')
    SeleniumController.Driver.find_element(:link_text, "#{link_text}").click
    #if acceptance_link.text == 'Accept Invitation'
    #  acceptance_link.click
    #else
    #  puts 'Invitation link not found'
  end
end