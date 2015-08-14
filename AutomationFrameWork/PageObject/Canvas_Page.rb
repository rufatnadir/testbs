require 'selenium-webdriver'
require 'rspec'
require_relative  '../../app/models/workspace_analyzer'
require_relative  '../UtilityClasses/Driver'
require_relative '../../Test/features/support/env'
#require 'test/unit'
#include Test::Unit::Assertions

class Canvas

  @wait = Selenium::WebDriver::Wait.new(:timeout => 10)

  def self.IsAt(workspace_name)
    sleep(5)
    if SeleniumController.Driver.find_element(:class => 'session-name').text == workspace_name
      return true
        else
          $log.warn 'Not at the Canvas page'
        return false
    end
  end

  def self.VerifyItemExists(environment, type, arg1, arg2, arg3)
    begin
      canvas_analyzer = WorkspaceAnalyzer.new(self.GetWorkspaceID, environment)
      return true if canvas_analyzer.find_item(type, arg1, arg2, arg3)
      false
    end
  end

  def self.VerifyItemMoved(environment, type, arg1, arg2, arg3, delta_x, delta_y)
    canvas_analyzer = WorkspaceAnalyzer.new(self.GetWorkspaceID, environment)
    return true if canvas_analyzer.find_moved_item(type, arg1, arg2, arg3, delta_x, delta_y)
    false
  end

  def self.AddANoteCard(note_text, color, caps )
    begin
      #add note card button click
      SeleniumController.Driver.find_element(:css => '#note-creator-button > i').click
      #typing the text
      SeleniumController.Driver.find_element(:class => 'webkit-backspace-textarea-fix').send_keys(note_text)
      #Selecting the color and font
      sleep(3)
      SeleniumController.Driver.find_element(:id, "panel-" + color + "-card-color").click

      SeleniumController.Driver.find_element(:css => '#note-creator > form > div.panel-body > div.button-groups.note-edit-modal-toolbar > div.button-group.case-pill-radio > input.note-style-'+caps).click

      SeleniumController.Driver.find_element(:css => "button[class*='save-note']").click

      SeleniumController.Driver.find_element(:css => '#note-creator-button > i').click
    rescue Exception => e
      $log.error "#{e}, Failed to add a note card due to missing or not found element"
      raise
    end
  end

  def self.CloseTour
    sleep(2)
    close_tour = SeleniumController.Driver.find_element(:css => 'body > div.walkthrough-overlay > div > a.close-tour-btn.dismiss.ui-icon-delete-o-circle')
    if close_tour.displayed?
      close_tour.click
    else
    puts 'Close tour button not displayed'
    end
  end

  def self.GetWorkspaceID
    full_url = SeleniumController.Driver.current_url
    workspace_id  = full_url.reverse[0...20].reverse
    return workspace_id
  end

  def self.ExitWorkspace
    sleep(3)
    begin
      SeleniumController.Driver.find_element(:css => '#toolbar > div.main-toolbar.tray > ul.functions > li.exit-workspace > a > i').click
      SeleniumController.Driver.find_element(:css => '#exit-workspace > div.panel-body > ul > li:nth-child(2) > a').click
    rescue Exception => e
      $log.error "#{e}, Cant find the exit workspace button"
      raise
    end
    puts 'Exiting workspace'
  end

  def self.UploadFileToCanvas(filename)
    begin
      SeleniumController.Driver.find_element(:css => 'input[type="file"]').send_keys(SeleniumController.GetProjectDirectory + filename)
    rescue Exception => e
      $log.error "#{e}, Upload file to canvas problem"
      raise
    end
    puts 'Uploading file to canvas'
  end

  def self.CheckForImage
    begin
      Selenium::WebDriver::Wait.new(timeout: 15).until {
      SeleniumController.Driver.find_element(:class => 'img-container')
      }
      image = SeleniumController.Driver.find_element(:class => 'img-container')
      if image.displayed?
        puts 'Passed. image exist'
        $log.info 'Passed. image exists'
      else
        puts 'Image not found'
        $log.info 'Image not found on canvas'
      end
    rescue Exception => e
      $log.error "#{e}, Cant find image on canvas"
      raise
    end
  end

  def self.CheckForPDF
    begin
      Selenium::WebDriver::Wait.new(timeout: 15).until {
        SeleniumController.Driver.find_element(:class => 'text-container')
      }
      file = SeleniumController.Driver.find_element(:class => 'text-container')

      if file.displayed?
        puts "Passed. File uploaded"
        $log.info 'Passed, PDF uploaded'
      else
        $log.error "File not found"
      end
    rescue Exception => e
      $log.error "#{e}, Cant find PDF on canvas"
    end
  end

  def self.CheckForLocationMarker
    begin
      location_marker = SeleniumController.Driver.find_element(:class => 'location-marker')

      if location_marker.displayed?
        $log.info "Location marker exist"
        puts "Location marker exist"
        return true
      end
    rescue Exception => e
      $log.error "#{e}, location marker not found"
      raise
    end
  end

  def self.CheckForMarkerWithColorAndText(color, text)
    markers = SeleniumController.Driver.find_elements(:class => 'location-marker')
    markers.keep_if {|marker|
    marker.text.include? text
          }
    if markers.count > 0
      puts "Marker with text: '#{text}' exist"
    else
      puts "Marker not found"
    end
  end

  def self.DeleteLocationMarker(text)
    markers = SeleniumController.Driver.find_elements(:class => 'location-marker')
    markers.keep_if {|marker|
      marker.text.include? text
    }
    markers[0].click
    markers[0].find_element(:class =>'delete').click
    puts "Location marker '#{text}' deleted"
  end

  def self.ClickBrowserButton
    begin
      SeleniumController.Driver.find_element(:id => 'web-browser-creator-button').click
    rescue Exception => e
      $log.error "#{e}, Cant find the Browser button on the Canvas"
      raise
    end
  end

  def self.AddABrowserToCanvas(browser_link)
    begin
      SeleniumController.Driver.find_element(:css => '#web-browser-creator > form > input').send_keys browser_link
      SeleniumController.Driver.find_element(:css => '#web-browser-creator > form > button').click
    rescue Exception => e
      $log.error "#{e}, Couldn't find one of the add browser elements canvas "
      raise
      #@browser_link = browser_link
    end
  end

  def self.AddMarker
    begin
      #to add color later.
      SeleniumController.Driver.find_element(:css => '#toolbar > div.main-toolbar.tray > ul.functions > li.location-markers > a > i').click
      sleep(2)
      SeleniumController.Driver.find_element(:css => '#location-markers > div > h4').click
    rescue Exception => e
      $log.error "#{e}, Add marker confirm button couldn't be found"
      raise
    end
  end

  def self.SetMarkerAttributes(color, title)
    begin
    SeleniumController.Driver.find_element(:css => '#new-location-marker > div > form > input').send_keys(title)
    SeleniumController.Driver.find_element(:css => 'label[for*=' + color + ']').click

    SeleniumController.Driver.find_element(:css => '#new-location-marker > div > form > div.submit-area > input').click
    SeleniumController.Driver.find_element(:css => '#toolbar > div.main-toolbar.tray > ul.functions > li.location-markers > a > i').click
    rescue Exception => e
      $log.error "#{e},Failed to set the marker color or title, one of the marker elements was not found"
      raise
    end
  end

  def self.CheckForBrowser(link)
    #SeleniumController.Driver.find_element(:class => 'zoom-out-icon').click
    browsers = SeleniumController.Driver.find_elements(:class => 'web-browser')
    browsers.each { |browser|
      if browser.text.include? link
      puts 'Browser displayed'
      return true
      end
        }

  end

  def self.FindNoteCardOnCanvas(note_card_text)
      notecards = SeleniumController.Driver.find_elements(:class => 'text-content')
      notecards.keep_if { |notecard|
        notecard.text.include? note_card_text
        $log.info "Notecard with text: '#{note_card_text}' exist"
        puts "Notecard with text: '#{note_card_text}' exist"
        return true
      }

  end

  def self.DoubleClickNoteCard(note_card_text)
      notecards = SeleniumController.Driver.find_elements(:class => 'text-container')
      puts notecards[1].text
      notecards.keep_if { |notecard| notecard.text.include? note_card_text
      SeleniumController.Driver.action.move_to(notecard[0]).double_click.perform
      }
      puts notecards[0]
    puts "Double click performed for notecard '#{note_card_text}'"
  end

  def self.ChangeNotecardColor(new_color)
    begin
    SeleniumController.Driver.find_element(:id => 'modal-' + new_color + '-card-color').click
      puts "Notecard color changed to #{new_color}"
    rescue Exception => e
      $log.error "#{e}, Couldn't find the note card color you are trying to select"
      raise
    end
  end

  def self.ChangeNotecardText(new_text)
    begin
      notecard_text = SeleniumController.Driver.find_element(:css => '#edit-note-modal > div > form > div.writer > textarea')
      notecard_text.clear
      notecard_text.send_keys new_text
      puts "Notecard text changed to: '#{new_text}'"
    rescue Exception => e
      $log.error "#{e}, Could not click on Note Card Save button after edit, not found may be!"
    end
  end

  def self.NoteCardSaveEdit
    begin
      SeleniumController.Driver.find_element(:class => "save-note").click
      puts "Notecard saved"
    rescue Exception => e
      $log.error "#{e}, Could not click on Note Card Save button after edit, not found may be!"

    end
  end

  def self.ClickAndHoldNoteCard(note_card_text,x_shift,y_shift)
    begin
      note_cards = SeleniumController.Driver.find_elements(:css => "div[class*='gesture-target note']")
      marker = SeleniumController.Driver.find_element(:css => "div[class*='location-marker']")
      i = 0
      while i < note_cards.count
        if note_cards[i].text == note_card_text
        #SeleniumController.Driver.action.drag_and_drop_by(note_cards[i], x_shift, y_shift).perform
          SeleniumController.Driver.action.drag_and_drop_by(note_cards[i], x_shift, 0).perform
          sleep(2)
          SeleniumController.Driver.action.drag_and_drop_by(note_cards[i], 0, y_shift).perform
          sleep(2)
        end
        i= i+1
      end
      if i == 0
      $log.error " couldn't find any note cards with this text on the canvas"
      end
    end
  end

  #incomplete, to revisit later
  def self.SetZoomTo(zoom_degree)
    begin
      plus = SeleniumController.Driver.find_element(:css => "i[class*='zoom-in-icon']")
      minus = SeleniumController.Driver.find_element(:css => "i[class*='zoom-out-icon']")
    end
  end

  def self.GiveNoteCardXCoordinates(note_card_text)

    note_cards = SeleniumController.Driver.find_elements(:css => "div[class*='gesture-target note']")
      i = 0
    j= -1
    while i < note_cards.count
      begin
      if note_cards[i].text == note_card_text
        j  = note_cards[i].attribute('style')
        j.to_s
        j = j[6..15]
        return j
      end
      i= i+1
    end
    return j
    end
  end

  def self.GiveNoteCardYCoordinates(note_card_text)
    note_cards = SeleniumController.Driver.find_elements(:css => "div[class*='gesture-target note']")
    i = 0
    while i < note_cards.count
      if note_cards[i].text == note_card_text
        j  = note_cards[i].attribute('style')
        j.to_s
        j = j[32..40]
        return j
      end
      i= i+1
    end
    return -1
  end

  def self.ClickOnPenIcon
    SeleniumController.Driver.find_element(:class => 'pen-toggle').click
    puts 'Click on pen icon on canvas'
  end

  def self.CheckIfPenControlsExist
    SeleniumController.Driver.find_element(:id => 'pen-controls').displayed?
    puts 'Pen toolbar displayed'
    return true
  end

  def self.SelectPenSize(size)
    @wait.until {SeleniumController.Driver.find_element(:class => 'brush-size-selector').displayed? }
    size_check = SeleniumController.Driver.find_element(:css => '[for="pen-size-'+size+'"]')
    puts "Selecting #{size} size for the pen"
    size_check.click
  end

  def self.VerifySizeChecked(size)
    sleep(1)
    size_select = SeleniumController.Driver.find_element(:css => '#pen-size-'+size)
    size_select.selected?
  end

  def self.SelectPenColor(color)
    case color
      when 'white'
        nth_child = '2'
      when 'gray'
        nth_child = '4'
      when 'yellow'
        nth_child = '6'
      when 'red'
        nth_child = '8'
      when 'green'
        nth_child = '10'
      when 'purple'
        nth_child = '12'
      when 'cyan'
        nth_child = '14'
    end
    sleep(1)
    color_select = SeleniumController.Driver.find_element(:css => '#pen-controls > div.panel-body.right > form > div.color-selector > label:nth-child('+nth_child+')')
    puts "Selecting the #{color} color for the pen"
    color_select.click
  end

  def self.VerifyColorChecked(color)
    sleep(1)
    color_select = SeleniumController.Driver.find_element(:css => '#pen-color-' + color)
    color_select.selected?
    return true
  end

  def self.ClickOnEraser
    SeleniumController.Driver.find_element(:class => 'eraser-button').click
    puts 'Clicking eraser icon'
  end

  def self.CheckIfSliderDisplayed
    SeleniumController.Driver.find_element(:class => 'eraser-slider').displayed?
  end

  def self.SetEraserWidthValue(value)
    SeleniumController.Driver.execute_script("document.getElementById('eraser-controls').setAttribute('value', '#{value}')") #//*[@id="eraser-controls"]/form/div[1]/input
  end

  def self.ClickScreenCastButton
    SeleniumController.Driver.find_element(:class => 'screenshare-button').click
    @wait.until {SeleniumController.Driver.find_element(:css => '#screenshare > div.panel-header').displayed?}
    puts 'Screencast dialog displayed'
  end

  def self.CheckStartSharingButton(text)
    button = SeleniumController.Driver.find_element(:css => '#screenshare-button')
    if button.text == text
      puts "Button '#{text}' exist"
      return true
    end
  end

  def self.SwitchToConferenceTab(tab_name)
    conference_tab = SeleniumController.Driver.find_element(:css => '#conference-self-button')
    if conference_tab.text == tab_name
      conference_tab.click
    end
  end

  def self.CheckTextOnConference(text)
    conference_tab = SeleniumController.Driver.find_element(:css => '#conference-previews > div > h2')
    if
    conference_tab.text == text
      puts 'Message displayed: ' + text
      return true
    end
  end

  def self.ClickShareOnMarker(marker_name)
    markers = SeleniumController.Driver.find_elements(:class => 'location-marker')
    markers.keep_if { |marker|
      marker.text.include?  marker_name
    }
    SeleniumController.Driver.action.move_to(markers[0]).perform
    @wait.until {SeleniumController.Driver.find_element(:class => 'share').displayed?}
    markers[0].click
    markers[0].find_element(:class => 'share').click
  end

  def self.CheckForBroadcastDialog(window_name)
    message_box_header = SeleniumController.Driver.find_element(:css => '#send-message-modal > div > form > div.message-sender-header > h4')
    if message_box_header.text == window_name
      puts 'Location Message window displayed'
      return true
    end
  end

  def self.SendBroadcastMessage(message)
    message_field = SeleniumController.Driver.find_element(:css => '#send-message-modal > div > form > div.form-group > textarea')
    message_field.send_keys message
    SeleniumController.Driver.find_element(:css => '#send-message-modal > div > form > div.form-group > div.button-groups > div.actions.button-group.save-btn > button').click
    puts 'Sending broadcast message: ' + message
    sleep(3)
  end

  def self.ClickGroupSelectionButton
    select_button = SeleniumController.Driver.find_element(:css => '#toolbar > div > ul.functions > li.select > a')
    #@wait.until {select_button.displayed?}
    select_button.click
  end

  def self.CheckIfSelectModes
    SeleniumController.Driver.find_element(:class => 'mode-buttons').displayed?
    return true
  end

  def self.SelectGroupMode
    SeleniumController.Driver.find_element(:link_text => 'lasso').click
  end

  def self.SelectMessageRecipientFromList(recipient)
    input_field = SeleniumController.Driver.find_element(:class => 'select2-search__field')
    input_field.send_keys recipient
    recipients = SeleniumController.Driver.find_elements(:class => 'select2-results__option')
    recipients.keep_if {
      |selection| selection.text.include? recipient
    }
    recipients[0].click
    puts "Selecting '#{recipient}' from list"
  end

  def self.VerifyMessageAlertDisplayed(message)
    alert = SeleniumController.Driver.find_element(:class => 'toast-top-center')
    puts "Alert text: " + alert.text
    if alert.text.include? message
      return true
      else puts "Alert not displayed"
    end
  end

  def self.ZoomIn
    @wait.until {SeleniumController.Driver.find_element(:css => '#zoom-buttons').displayed?}
    SeleniumController.Driver.find_element(:class => 'zoom-in-icon').click
  end

end
