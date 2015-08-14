require 'selenium-webdriver'
require 'rspec'
require_relative  '../UtilityClasses/Driver'
require 'selenium/webdriver/common/target_locator'

# noinspection RubyDynamicConstAssignment
class WorkspaceList
  @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
  @session_id = nil

  def self.CheckIfAtWorkspacesList
    sleep(2)
    SeleniumController.Driver.find_element(:class => 'new-session').displayed?
    puts 'Successfully logged in to hub'
    return true
  end

  def self.CreateWorkspace(name)
    WorkspaceList.PressNewWorkspaceButton
    WorkspaceList.EnterWorkspaceName(name)
    WorkspaceList.PressCreateButton
    puts "Creating new workspace: #{name}"
  end

  def self.PressNewWorkspaceButton
    new_ws_button = SeleniumController.Driver.find_element(:class => 'new-session')
    new_ws_button.click
    @wait.until {SeleniumController.Driver.find_element(:css => '#new_editable_session > div.modal-body > div.form-group.string.required.editable_session_name').displayed?}
  end

  def self.EnterRandomWorkspaceName(workspace_name)
    random = (0...5).map { (65 + rand(26)).chr }.join
    SeleniumController.Driver.find_element(:id => 'editable_session_name').send_keys workspace_name + random
  end

  def self.EnterWorkspaceName(workspace_name)
    ws_name_field = SeleniumController.Driver.find_element(:css => '#editable_session_name')
    ws_name_field.clear
    ws_name_field.send_keys workspace_name
  end

  def self.EnterWsDescription(description)
    ws_description_field = SeleniumController.Driver.find_element(:css => '#editable_session_description')
    ws_description_field.clear
    ws_description_field.send_keys description
  end

  def self.OpenWorkspaceStatus
    SeleniumController.Driver.find_element(:css => '#session-wxKst2qqgDqFKhv8n4gb > td.share-session > a').click
  end

  def self.ClickPublicCheckbox
    SeleniumController.Driver.find_element(:id => 'editable_session_public').click
  end

  def self.ClickPrivateCheckbox
    sleep(2)
    SeleniumController.Driver.find_element(:id => 'editable_session_public_false').click
  end

  def self.PressCreateButton
    SeleniumController.Driver.find_element(:css => '#new_editable_session > div > input').click
  end

  def self.ClickOptionsButton(ws_name)
    workspaces_list =  SeleniumController.Driver.find_elements(:class => 'hub-sessions-list-item')
    workspaces_list.keep_if { |workspace|
      workspace.text.include? ws_name
    }
    workspaces_list[0].find_element(:class => 'options').click
  end

  def self.WorkspaceInList(workspace_name)
    workspaces_with_this_name = SeleniumController.Driver.find_elements(:partial_link_text => workspace_name)
    if  workspaces_with_this_name.count > 0
      return true
    else
      return false
    end
  end

  def self.OpenWsSettings(ws_name)
    workspace_name_length = ws_name.length - 1
    workspaces_list =  SeleniumController.Driver.find_elements(:css => "tr[class*='sessions-list-item']")
    i = 0
    while i < workspaces_list.count
      name_only = workspaces_list[i].text
      if name_only[0..workspace_name_length] == ws_name
        setting_button = workspaces_list[i].find_element(:class => 'options')
        setting_button.click
        SeleniumController.Driver.find_element(:link_text => 'Edit Workspace Settings').click
        i = workspaces_list.count
      end
      i= i+1
    end
  end

  def self.ClickSendToWallForWorkspace(ws_name)
    workspace_name_length = ws_name.length - 1
    workspaces_list =  SeleniumController.Driver.find_elements(:css => "tr[class*='sessions-list-item']")
    i = 0
    while i < workspaces_list.count
      name_only = workspaces_list[i].text
      #puts name_only
      #puts name_only[0..workspace_name_length]
      if name_only[0..workspace_name_length] == ws_name
        send_to_wall_button = workspaces_list[i].find_element(:class => 'send-to-wall')
        send_to_wall_button.click
        i = workspaces_list.count
      end
      i= i+1
    end
  end

  def self.EnterWallPIN(pin)
    wall_pin_field = SeleniumController.Driver.find_element(:css => '#send_to_wall_request_pin')
    sleep(3)
    wall_pin_field.clear
    wall_pin_field.send_keys pin
  end

  def self.ClickSendToWallOnModalWindow
    SeleniumController.Driver.find_element(:class => "send_to_wall_request").submit
  end


  def self.ClickSaveButton
    SeleniumController.Driver.find_element(:css => '#edit_editable_session > div.action-container > input').click
  end

  def self.GetWorkspaceIdFromWorkspaceName(workspace_name)
    link_to_workspace =SeleniumController.Driver.find_element(:link_text => workspace_name)
    workspace_id  = link_to_workspace.attribute('href').reverse[0...20].reverse
    return workspace_id
  end

  def self.GoToWorkspace(workspace_name)
    sleep(2)
    link_to_workspace = SeleniumController.Driver.find_elements(:class => 'session-link')
    link_to_workspace.keep_if { |session|
      session.text.include? workspace_name
        }
    link_to_workspace[0].click
    SeleniumController.Driver.switch_to.window(SeleniumController.Driver.window_handles.last)
    sleep(3)
    SeleniumController.Driver.action.move_to(:css => 'body > div.walkthrough-overlay > div > a.close-tour-btn.dismiss.ui-icon-delete-o-circle').click
=begin
      @wait.until {SeleniumController.Driver.find_element(:xpath => '/html/body/div[14]/div/a[2]').displayed?}
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts 'Close tour button not displayed'
    ensure SeleniumController.Driver.action.move_to(:xpath => '/html/body/div[14]/div/a[2]').click

=end
  end

  def self.OpenShareScreen(workspace_name)
    ClickOptionsButton(workspace_name)
    SeleniumController.Driver.find_element(:link_text => 'Edit Permissions').click
  end

  def self.CheckSharingStatus(ws_name, status)
    workspaces_list = SeleniumController.Driver.find_elements(:css => 'tr[class*="sessions-list-item"]')
    workspaces_list.keep_if { |workspace|
      workspace.text.include? ws_name
    }
    puts workspaces_list[0][4]
    if workspaces_list[0].find_element(:class => 'sharing-' + status).displayed?
      puts "Sharing status of the '#{ws_name}' is '#{status}'"
      return true
    else
      puts "Sharing status incorrect"
    end
  end

  def self.CheckOwnership(ws_name, owner)
    workspaces_list = SeleniumController.Driver.find_elements(:class => 'hub-sessions-list-item')
    workspaces_list.keep_if { |workspace|
      workspace.text.include? ws_name
    }
    owner_name = workspaces_list[0].find_element(:class => 'owner-name')
     if owner_name.text.include? owner
      puts "Pass: Workspace " + owner_name.text
      return true
    else
      puts "Failed: Workspace " + owner_name.text
      return false
     end
  end


  def self.CheckIfAtWorkspaceListPage
    SeleniumController.Driver.find_element(:class => 'session-list-container').displayed?
  end

  def self.ArchiveWorkspaceByID(workspace_id)
    SeleniumController.Driver.find_element(:xpath => '//*[@id="session-' + workspace_id + '"]/td[2]').click
    SeleniumController.Driver.find_element(:css => '#session-' +workspace_id +' > td.edit-session > a').click
    SeleniumController.Driver.navigate.refresh
    SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.row > div.span5.pull-left > ul > li:nth-child(2) > a > i').click
    alert_popup = SeleniumController.Driver.switch_to.alert
    alert_popup.accept
    puts 'Workspace archived'
  end

  def self.CreateWorkspaceByRandomName(name)
      WorkspaceList.PressNewWorkspaceButton
      WorkspaceList.EnterRandomWorkspaceName(name)
      WorkspaceList.PressCreateButton
      puts "Workspace '#{name}' created"
  end

  def self.CreateNumberOfWorkspaces(number, name)
    workspaces_list =  SeleniumController.Driver.find_elements(:class =>'sessions-list-item')
    workspaces_max = number.to_i
    i = workspaces_list.count
    until i == workspaces_max do
      WorkspaceList.CreateWorkspaceByRandomName(name)
      i += 1
    end
  end

  def self.CheckIfButtonDisabled
    SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.row.hub-page > div.col-xs-8 > div:nth-child(1) > div.col-xs-8 > div.new-session.pull-right').displayed?
  end

  def self.SessionsUsageInfo(text)
    usage_info = SeleniumController.Driver.find_element(:class => 'session-usage')
    if usage_info.text.include? text
    puts usage_info.text
      return true
    end
  end

  def self.ArchiveWorkspaceByName(workspace_name)
    OpenWsSettings(workspace_name)
    SeleniumController.Driver.find_element(:class => 'trash').click
    sleep(2)
    alert_popup = SeleniumController.Driver.switch_to.alert
    alert_popup.accept
    puts "Workspace '#{workspace_name}' archived"
  end

  def self.ClickArchiveWSButton
    SeleniumController.Driver.find_element(:class => 'trash').click
    alert_popup = SeleniumController.Driver.switch_to.alert
    alert_popup.accept
    sleep(2)
  end

  def self.DuplicateWorkspaceByName(workspace_name)
    OpenWsSettings(workspace_name)
    SeleniumController.Driver.find_element(:class => 'duplicate').click
    SeleniumController.Driver.switch_to.active_element
    ws_name_field = SeleniumController.Driver.find_element(:css => '#session_copy_request_name')
    sleep(2)
    puts "Duplicating workspace: #{workspace_name}"
    ws_name_field.clear
    ws_name_field.send_keys 'DuplicateWS'
    duplicate_btn = SeleniumController.Driver.find_element(:css => 'body > div.container.content-main > div.modal.fade.js-modal-duplicate.in > div > div > form > div.modal-body > input.btn.btn-primary')
    duplicate_btn.click
    sleep(2)
  end

  def self.GoToUsersTab
    @wait.until {SeleniumController.Driver.find_element(:css => '#navbar-user-icon').displayed? }
    SeleniumController.Driver.find_element(:id => 'navbar-user-icon').click
    puts 'Clicking on users tab'
  end

  def self.CheckIfAtSharingScreen(page_name)
    @wait.until {SeleniumController.Driver.find_element(:class => 'table-header').displayed?}
    #puts SeleniumController.Driver.find_element(:class => 'table-header').text
    if SeleniumController.Driver.find_element(:class => 'table-header').text.include? page_name
      return true
    end
  end

  def self.EnterGuestEmail(domain)
    random = (0...5).map { (65 + rand(26)).chr }.join
    $email = random + domain
    sleep(2)
    SeleniumController.Driver.find_element(:css => "#session_sharing_form_email").send_keys $email
  end

  def self.ClickAddGuestButton
    SeleniumController.Driver.find_element(:name, "commit").click
  end

  def self.CheckShareAlert(alert_text)
    alert = SeleniumController.Driver.find_element(:class => 'alert-info')
    if alert.text.include? alert_text
      $log.add 'Alert message displayed'
      return true
      else $log.error 'Message not displayed'
    end
  end

  def self.SignOut
    begin
    @wait.until { SeleniumController.Driver.find_element(:class => 'user-settings').displayed? }
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      puts "Catching error, retry"
    ensure SeleniumController.Driver.find_element(:class => 'user-settings').click
    end
    puts 'Signing out'
    @wait.until {SeleniumController.Driver.find_element(:class => 'user-settings-sign-out').displayed? }
    SeleniumController.Driver.find_element(:class => 'user-settings-sign-out').click  #Click "Sign out" button
    SeleniumController.KillBrowser
  end

  def self.MakeWorkspacePublic
    SeleniumController.Driver.find_element(:id => 'editable_session_public_true').click
    puts 'Making workspace public'
  end

  def self.BackToWorkspacesList
    SeleniumController.Driver.find_element(:class, 'left-arrow').click
  end

  def self.SelectLink(value)
    SeleniumController.Driver.find_element(:link_text, value).select
  end

  def self.CheckIfTimeUpdated(ws_name)
    workspaces_list = SeleniumController.Driver.find_elements(:css => "tr[class*='sessions-list-item']")
    workspaces_list.keep_if { |workspace|
      workspace.text.include? ws_name
    }
    last_modified_time = workspaces_list[0].find_element(:class => 'date-modified')
    puts "Workspace last modified time: #{last_modified_time.text}"
    current_time = Time.now.strftime("%-I:%M %P").to_s
    puts "Current time: #{current_time}"

    if last_modified_time.text == current_time
      return true
    end
  end

  def self.ChangeWorkspaceOwner(owner)
    owners_list = SeleniumController.Driver.find_element(:id => 'editable_session_owner_id')
    options = owners_list.find_elements(:tag_name => 'option')
    exist_in_list = false
    i = 0
    while i < options.count
      if options[i].text == owner
          options[i].click
          exist_in_list = true
      end
      i= i+1
    end
    raise 'Username you provided not exist in list' unless exist_in_list
  end

  def self.ClickFavoriteStar(workspace_name)
    sleep(2)
    workspaces_list = SeleniumController.Driver.find_elements(:class => 'hub-sessions-list-item')
    workspaces_list.keep_if { |workspace|
      workspace.text.include? workspace_name
    }
    #puts workspaces_list[0].text
    workspaces_list[0].find_element(:class => 'star-empty').click
      puts "Adding workspace #{workspace_name} to favorites"
  end

  def self.CheckIfWsinFavorites(ws_name)
    workspaces_list = SeleniumController.Driver.find_elements(:css => "tr[class*='sessions-list-item']")
    workspaces_list.keep_if { |workspace|
      workspace.text.include? ws_name
          }
    begin workspaces_list[0].find_element(:class => 'star-full').displayed?
      puts 'Passed: Workspace in favorites!'
      return true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts 'Failed: Workspace not in favorites'
    end
  end

  def self.UncheckFavoriteStar(ws_name)
    workspaces_list = SeleniumController.Driver.find_elements(:css => "tr[class*='sessions-list-item']")
    workspaces_list.keep_if { |workspace|
      workspace.text.include? ws_name
    }
    begin
    workspaces_list[0].find_element(:class => 'star-full').click
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts 'Workspace not in favorites'
    end

  end

  def self.ReturnWorkspacesOnList
    @workspaces = SeleniumController.Driver.find_elements(:class => 'session-name')
    puts "There are '#{@workspaces.count}' workspaces in list"
  end

  def self.ClickSortingWorkspaces
    dropdown = SeleniumController.Driver.find_element(:id => 'sort-control')
    #puts dropdown.to_s
    dropdown.click
  end

  def self.SelectDropdownEntry(entry)
    options = SeleniumController.Driver.find_elements(:class => 'dropdown-entry')
    options.keep_if { |option| option.text == entry
    }
    options[0].click

  end

  def self.CheckSessionNamesSorting
    session_names = SeleniumController.Driver.find_elements(:class => 'session-name')
    session_names.shift
    sleep(2)
    session_names.each { |name| puts name.text }

    #sorted_session_name = session_names.sort!
    #sorted_session_name.each_index { |name|
    #  puts name.text
    #}
    #if session_names == sorted_session_name
    #  puts 'Pass: Workspace names sorted alphabetically'
    #  return true
    #end
  end

  def self.TypeKeywordInSearchField(keyword)
    search_field = SeleniumController.Driver.find_element(:css => '#search > div > input')
    search_field.send_keys keyword
    sleep(2)
  end

  def self.CheckIfSessionsFilteredByKeyword(keyword)
    workspaces = SeleniumController.Driver.find_elements(:class => 'session-name')
    puts "There are #{workspaces.count} workspaces in filtered list"
    workspaces.each { |name|
      name.text.include? keyword
        puts "Workspace matching filter: '#{name.text}'"
        return true
      }
  end

  def self.ClearSearch
    SeleniumController.Driver.find_element(:class => 'cancel').click
    sleep(2)
  end

  def self.CheckIfFilterCleared
    workspaces = SeleniumController.Driver.find_elements(:class => 'session-name')
    puts "There are #{workspaces.count} workspaces after filter cleared"
    if workspaces.count == @workspaces.count
      puts 'Filter cleared, all workspaces displayed'
      return true
    end
  end

  def self.CheckMessageInInbox(message, sender)
    messages = SeleniumController.Driver.find_elements(:class => 'list-group-item')
    messages.keep_if { |item|
      item.find_element(:class => 'message-sender').text == sender and
      item.find_element(:class => 'message-body').text.include? message
     }
    @message = messages[0]
    if messages[0]
      messages[0].click
      puts 'Message found'
      return true
    end
    #messages[0].find_element(:class => 'increased-tappability').click if messages[0] != nil
  end

  def self.EnterWorkspaceThroughMessage
    @message.find_element(:class => 'increased-tappability').click
    puts 'Opening workspace from broadcast message'
    SeleniumController.Driver.switch_to.window(SeleniumController.Driver.window_handles.last)
    @wait.until {SeleniumController.Driver.find_element(:css => 'body > div.walkthrough-overlay > div > a.close-tour-btn.dismiss.ui-icon-delete-o-circle').displayed?}
    sleep(3)
    close_tour = SeleniumController.Driver.find_element(:css => 'body > div.walkthrough-overlay > div > a.close-tour-btn.dismiss.ui-icon-delete-o-circle')
    if close_tour.displayed?
      close_tour.click
    else
      puts '"Close tour" button not displayed'
    end
  end

end
