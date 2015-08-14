require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'
require_relative '../../Test/features/support/env'
#require 'test/unit'

class DashboardPage

  @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  def self.GoTo
    begin
      SeleniumController.Driver.navigate.to 'https://acceptance.portal.bluescape.com/dashboard'
    rescue Exception => e
      $log.error "#{e}, Cant find the Dashboard page title"
      #use raise if you would like to fail this test case when all said is done
      raise
    end
  end

  def self.IsAt?
    begin

      @page_title = false
      @page_title = SeleniumController.Driver.find_element(:link_text => 'My Dashboard')
      if @page_title.text == 'My Dashboard'
        return true
      end
      return false
    rescue Exception => e
      $log.error "#{e}, Cant find the Dashboard page title"
      raise
    end
  end

  def self.CheckIfAtHubPage
    begin
      @wait.until {SeleniumController.Driver.find_element(:class => 'workspaces-header').displayed?}
    rescue Exception => e
      $log.error "#{e}, Cant find the Dashboard page title"
      #use raise if you would like to fail this test case when all said is done
      raise
    end
  end

  def self.CheckIfGreetingDisplay(greeting)
    greeting_container = SeleniumController.Driver.find_element(:css => '#quick-start > div > div.item.active > div > div.modal-header > h2')
    if greeting_container.text == greeting
      return true
    else
      puts "Greeting not displayed!"
      $log.warn 'Greeting not displayed on Dashboard page'
    end
  end

  def self.CheckIfOrgListDisplay
    begin
      SeleniumController.Driver.find_element(:class, "organization-listing").displayed?
    rescue Exception => e
      $log.error 'Failed, Organization list not displayed'
      raise
    end
  end

  def self.SelectOrganizationLink(organization_name)
     begin
       sleep(1)
       DashboardPage.OpenOrgNameDropDown
       organization = SeleniumController.Driver.find_element(:partial_link_text => organization_name)
       organization.click
    rescue Exception => e
      $log.error "#{e}, could not find the Organization name in Dashboard page"
      raise
    end
  end

  def self.ClickOrganizationLink
    SeleniumController.Driver.find_element(:class, "organization-listing").click
  end

  def self.OpenUserNameDropDown
    begin
      SeleniumController.Driver.find_element(:class => 'user-settings').click
    rescue Exception => e
      $log.error "#{e}, could not find the account pop up button"
      #use raise if you would like to fail this test case when all said is done
      raise
    end
  end

  def self.OpenOrgNameDropDown
    SeleniumController.Driver.find_element(:class => 'navbar-org-name').click
  end

  def self.ConfirmMemberRole(role_to_compare_to)
    begin
      #organization = SeleniumController.Driver.find_element(:class => 'org-link')
      roles = SeleniumController.Driver.find_elements(:class => 'right')
      roles.keep_if{ |role|
        role.text.include? role_to_compare_to
      }
      $log.info roles[0].text
        if roles[0].text.include? role_to_compare_to
          puts 'Passed! Member role is: ' + role_to_compare_to
          return true
        end
    rescue Exception => e
      $log.error "#{e}, Could not find the account role"
      raise
    end
  end

  def self.OpenSupportForm
    begin
      SeleniumController.Driver.find_element(:class => 'help').click
        SeleniumController.Driver.find_element(:class => 'support-link').click
    rescue Exception => e
      $log.error "#{e}, Not able to find Support link"
      raise
    end
    puts 'Open support form'
  end

  def self.SelectSubjectForSupport(subject)
    sleep(2)
    drop_down = SeleniumController.Driver.find_element(:class => 'support_request_request_type')
    options = drop_down.find_elements(tag_name: 'option')
    i = 0
    while i < options.count
      if options[i].text == subject
        options[i].click
      end
      i = i+1
    end
    puts 'Select subject for support'
  end

  def self.FillInSupportFields(field1, field2)
    SeleniumController.Driver.find_element(:css => '#support_request_subject').send_keys field1
    SeleniumController.Driver.find_element(:css => '#support_request_body').send_keys field2
    puts 'Filling support form'
  end

  def self.CloseHelpDialog
    begin
      SeleniumController.Driver.find_element(:css => 'body > div.modal.fade.js-create-support-request.support-request-modal.in > div > div > div > button').click
    rescue Exception => e
      $log.error "#{e}, Unable to close Help Dialog"
      raise
    end
    puts 'Close Help dialog'
  end

  def self.CloseSupportForm
    SeleniumController.Driver.find_element(:css => 'body > div.modal.fade.js-create-support-request.support-request-modal.in > div > div > div > button').click
    puts 'Close support form'
  end

  def self.ClickHelpLink
    begin
      SeleniumController.Driver.find_element(:class => 'help').click
      SeleniumController.Driver.find_element(:class => 'help-link').click
    rescue Exception => e
      $log.error "#{e}, Not able to find Help link"
      raise
    end
  end

  def self.CheckBluescapeLogo
    begin
      bluescape_logo = SeleniumController.Driver.find_element(:class, 'navbar-brand')
      if bluescape_logo.displayed?
        puts 'Logo displayed'
        return true
      end
    rescue Exception => e
      $log.error "#{e}, Not able to find Help link"
      raise
    end
  end

  def self.VerifyTrialBanner
    SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div:nth-child(1) > div')
    puts 'Pass! Trial banner displayed'
  end

  def self.CheckIfAtSignInPage(page_name)
    begin
      SeleniumController.Driver.switch_to.window(SeleniumController.Driver.window_handles.last)
      sleep(2)
      header = SeleniumController.Driver.find_element(:css => '#devise-form-container')
      if header.text.include? page_name
        puts "Sign in page opened"
        $log.info "Sign in page opened"
        return true
      else
        puts "Failed: Sign in page not opened"
        $log.warn "Sign in page not opened"
        return false
      end
    rescue Exception => e
      $log.error "#{e}, Failed to find the header in Dashboard page"
      raise
    end
  end

  def self.CheckNoOrgMessage(message)
    modal_dialog = SeleniumController.Driver.find_element(:class => 'modal-header')
    if modal_dialog.text == message
      puts 'Pass: Message displayed'
      return true
    end
  end

  def self.Highlight(element_text, duration = 3)
    element = SeleniumController.Driver.find_element(:link_text => element_text)

    #store original style so it can be reset later
    original_style = element.attribute("style")

    SeleniumController.Driver.execute_script(
                                 "arguments[0].setAttribute(arguments[1], arguments[2])",
                                 element,
                                 "style",
                                 "border: 2px solid red; border-style: dashed;")

    #keep element highlighted for a spell and then revert
    if duration > 0
      sleep duration
      SeleniumController.Driver.execute_script(
          "arguments[0].setAttribute(arguments[1], arguments[2])",
          element,
          "style",
          original_style)
    end
  end

  def self.HighlightBluescapeLogo(duration = 3)
    logo = SeleniumController.Driver.find_element(:class => 'navbar-brand')
    original_style = logo.attribute("style")

    SeleniumController.Driver.execute_script(
        "arguments[0].setAttribute(arguments[1], arguments[2])",
        logo,
        "style",
        "border: 2px solid red; border-style: dashed;")

    #keep element highlighted for a spell and then revert
    if duration > 0
      sleep duration
      SeleniumController.Driver.execute_script(
          "arguments[0].setAttribute(arguments[1], arguments[2])",
          logo,
          "style",
          original_style)
    end
  end
end
