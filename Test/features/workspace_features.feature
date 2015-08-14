@rufat
@complete
@user

Feature: Test workspace features

  Scenario: Getting to workspaces list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page
    When I click on a workspace link "StrokesTest"
    Then The workspace "StrokesTest" canvas page should load successfully


  Scenario: Select pen width and colors
    Given I'm on the "StrokesTest" workspace canvas
    When I click on Pen icon
    Then Pen toolbar will open
    And I select "large" size for the pen
    Then "large" size for the pen will be selected
    When I select "medium" size for the pen
    Then "medium" size for the pen will be selected
    And I select "yellow" color for the pen
    Then "yellow" color for the pen will be selected
    And I select "green" color for the pen
    Then "green" color for the pen will be selected
    And I select "red" color for the pen
    Then "red" color for the pen will be selected
    When I click on Eraser icon
    Then The eraser slider will open

  Scenario: Check screencast elements
    Given I'm on the "StrokesTest" workspace canvas
    When I click on screencast button
    Then Screencast dialog will open
    And "Start Sharing" button exist
    When I click on "Shared by others" tab
    Then "No shared screens" message displayed


  Scenario: Send broadcast message
    Given I'm on the "StrokeTest" workspace canvas
    When I click the marker button on the canvas
    And Select marker color: "green" and gives it title: "Broadcast"
    Then Marker with color "green" and text "Broadcast" should be created on the canvas
    When I click on Share button on "Broadcast" markers label
    Then "Location Message" dialog will open
    When I select "Frank Underwood" from message receivers list
    And I enter message "Hello Frank" in text area and send it
    Then "Message successfully sent!" banner wil display on top of the canvas
    And Close screen

#  Scenario: Check group selection
#    Given I'm on the "StrokesTest" workspace canvas
#    When I click the Selection button on canvas
#    Then Group selection modes will display
#    And I select lasso mode and select marque mode
#    Then Close screen

  Scenario: Check if broadcast message delivered
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "test0205@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page
    And There is a message "Hello Frank" from user "Organization User"
    When I click on Enter Workspace button inside the message
    Then The workspace "StrokesTest" canvas page should load successfully
    And I delete marker "Broadcast" on canvas
    And Close screen

