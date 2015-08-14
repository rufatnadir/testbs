require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'
require_relative '../PageObject/Browser'
#require 'test/unit'
require 'selenium/webdriver/common/target_locator'

class OrgSettings
  def self.EnterCardNumber(card_number)
    SeleniumController.Driver.find_element(:class, 'credit-card-field').send_keys card_number
  end

  def self.EnterCardDatesAndCode(date1, date2, code)
    date_list = SeleniumController.Driver.find_element(:css => '#checkout_form_credit_card_month')
    date_list.find_elements(:tag_name, 'option').each do |option|
      option.click if option.text == date1
    end
    year_list = SeleniumController.Driver.find_element(:css => '#checkout_form_credit_card_year')
    year_list.find_elements(:tag_name, 'option').each do |year|
      year.click if year.text == date2
    end
    SeleniumController.Driver.find_element(:css => '#checkout_form_credit_card_verification_value').send_keys code
  end

  def self.EnterCredentials(first_name, last_name, street, city)
    @random = (0...5).map { (65 + rand(26)).chr }.join
    SeleniumController.Driver.find_element(:id, 'checkout_form_credit_card_first_name').send_keys first_name + @random
    SeleniumController.Driver.find_element(:id, 'checkout_form_credit_card_last_name').send_keys last_name + @random
    SeleniumController.Driver.find_element(:id, 'checkout_form_billing_info_address1').send_keys street
    SeleniumController.Driver.find_element(:id, 'checkout_form_billing_info_city').send_keys city
  end

  def self.EnterStateAndZip(state, zipcode)
    states_list = SeleniumController.Driver.find_element(:id, 'checkout_form_billing_info_state')
    states_list.find_elements(:tag_name, 'option').each do |option|
      option.click if option.text == state
    end
    SeleniumController.Driver.find_element(:id, 'checkout_form_billing_info_zip').send_keys zipcode
  end

  def self.ClickPurchasePlan
    SeleniumController.Driver.find_element(:css => '#new_checkout_form > div.plan-summary > div.purchase-action.pull-left > input').click
  end

  def self.CheckAlertNotice(alert_text)
    alert = SeleniumController.Driver.find_element(:class => 'alert-info')
    if alert.text.include? alert_text
      puts "Test Passed, alert displayed: #{alert.text}"
      return true
    end
  end

  def self.OpenOrganizationSettings
    SeleniumController.Driver.find_element(:css => '[title="Organization Settings"]').click
  end

  def self.ClickUpgradePlan
    SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.row.row-margin-left.settings-actions > div > a.btn.btn-primary.pull-left').click
  end

  def self.CheckIfAtUpgradePage(header)
    page_header = SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.checkout-form > h2')
    if page_header.text.include? header
      puts "Plan selection page displayed"
    else puts "Not in plan selection page"
    end
  end

  def self.SelectPlan(plan)
    SeleniumController.Driver.find_element(:css => '#new_checkout_form > div.form-inputs > div > div.limited-plan.plan-module.' + plan + '-plan > h3').click
  end

  def self.CheckPrice(price)
    price_displayed = SeleniumController.Driver.find_element(:css => '#new_checkout_form > div.plan-duration-select > span.duration-total > span')
    if price_displayed.text == price
      puts "Price is correct: " + price_displayed.text
      else puts "Price is not correct"
    end
  end

  def self.SelectAdminApproveCheckBox(checkbox_name)
    checkbox = SeleniumController.Driver.find_element(:id, 'invite_approval_form_guest_invite_requires_approval')
    puts checkbox.attribute('checked').nil?
    checkbox.click if checkbox.attribute('checked').nil?
  end

  def self.UnselectAdminApprovalCheckbox
    checkbox = SeleniumController.Driver.find_element(:id, 'invite_approval_form_guest_invite_requires_approval')
    puts checkbox.selected?.inspect
    if
    checkbox.selected?.inspect == 'true'
    checkbox.click
    else
      puts 'Checkbox unselected'
    end
  end


  def self.OpenUserSettings(user_name)
    sleep(2)
    org_members = SeleniumController.Driver.find_elements(:class, 'list-item')
    org_members.keep_if { |member|
     member.text.include? user_name
    }
    org_members.each { |member1|
      member1.find_element(:class, 'member-edit').click
    }
    puts "Opening user settings for user: #{user_name}"
  end

  def self.ClickOnUpgradeLink
    sleep(2)
    SeleniumController.Driver.find_element(:link_text => 'Upgrade Guest to Organization Member').click
    sleep(2)
    SeleniumController.Driver.switch_to.alert.accept
  end

  def self.ClickOnDowngradeLink
    SeleniumController.Driver.find_element(:link_text => 'Downgrade Organization Member to Guest').click
    sleep(2)
    SeleniumController.Driver.switch_to.alert.accept
  end

  def self.ChangeUserFirstName(new_name)
    username_field = SeleniumController.Driver.find_element(:id, 'organization_user_form_first_name')
    sleep(2)
    username_field.clear
    username_field.send_keys new_name
  end

  def self.ChangeUserLastName(new_name)
    lastname_field = SeleniumController.Driver.find_element(:id, 'organization_user_form_last_name')
    lastname_field.clear
    lastname_field.send_keys new_name
  end

  def self.ChangeUserPhone(new_phone)
    phone_field = SeleniumController.Driver.find_element(:id, 'organization_user_form_phone_number')
    phone_field.clear
    phone_field.send_keys new_phone
  end

  def self.CheckSuccessAlert(alert_text)
    alert = SeleniumController.Driver.find_element(:class, 'alert-success')
    if alert.text.include? alert_text
      puts 'Test Passed, alert displayed: ' + alert.text
    else
      puts 'Test Failed, alert: ' + alert.text
    end
  end

  def self.CheckMemberRole(member_name, member_role)
    sleep(1)
    org_members = SeleniumController.Driver.find_elements(:class, 'list-item')
    org_members.keep_if { |member|
      member.text.include? member_name
        }
    sleep(2)
      sorted_role = org_members[0].text.split[-1]
      puts "Role is: #{sorted_role}"
        if sorted_role == member_role
          puts 'Test passed: Members role is ' + sorted_role
        else
          puts 'Test failed: Members role is ' + sorted_role
        end
  end

  def self.ClickAdminCheckBox
    SeleniumController.Driver.find_element(:id, 'organization_user_form_admin').click
  end

  def self.CheckPlanBenefits(plan, storage, workspaces, users)
    storage_limit = SeleniumController.Driver.find_element(:css => '#new_checkout_form > div.form-inputs > div > div.limited-plan.plan-module.' + plan + '-plan.selected > ul > li:nth-child(1)')
    puts storage_limit.text
    workspaces_limit = SeleniumController.Driver.find_element(:css => '#new_checkout_form > div.form-inputs > div > div.limited-plan.plan-module.' + plan + '-plan.selected > ul > li:nth-child(2)')
    puts workspaces_limit.text
    users_limit = SeleniumController.Driver.find_element(:css => '#new_checkout_form > div.form-inputs > div > div.limited-plan.plan-module.' + plan + '-plan.selected > ul > li:nth-child(3)')
    puts users_limit.text
    if storage_limit.text == storage && workspaces_limit.text == workspaces && users_limit.text == users
      puts "Pass! Benefits are correct: #{storage_limit.text}, #{workspaces_limit.text}, #{users_limit.text}"
      return true
    end
  end

  def self.CheckImageIcons(class_name)
    image_file = SeleniumController.Driver.find_element(:class => class_name)
    image_exist = SeleniumController.Driver.execute_script("return arguments[0].complete && typeof arguments[0].naturalWidth != \"undefined\" && arguments[0].naturalWidth > 0", image_file)

    if image_exist
      puts "Image exist"
    else
      puts 'Image not there'
    end
  end

end

