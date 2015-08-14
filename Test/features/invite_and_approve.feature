@rufat
@complete
@owner @user @admin
@ciready

Feature: Invite guest to the workspace and approve invitation by admin

  Scenario: Change User settings by org owner
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.owner@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    Then I should be able to login successfully
    And The user click the Organization link "Enterprise Test"
    When I click on organization settings
    And Select checkbox "Guest invites require admin approval"
    And Close screen

  Scenario: Invite guest to workspace as user and check alert
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.user@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    And User click Sharing link of the workspace "GuestInviteTest"
    #Then should successfully open workspace "Sharing Status" page
    When I'm entering guests email "@mailinator.com" on email field
    And Click on Share button
    Then Alert "Workspace shared to guest pending admin approval" will appear on the page
    And Close screen

  Scenario: Check that guest did not receive invitation yet
    Given I'm on the mailinator home page "http://mailinator.com"
    When I enter guest email from step above
    And Click on Check it button
    Then Guest email is empty
    And Close screen

  Scenario: Check if admin received invitation and approve guest
    Given I'm on the mailinator home page "http://mailinator.com"
    When I enter user email "automation.org.adm"
    And Click on Check it button
    Then I open an email with subject "A guest needs approval"
    And I click on "View Users" link
    Then "Sign in to your Bluescape Account" page will open on new tab
    When User enters the correct the user id automation.org.adm@mailinator.com and password Nr_3181299
    Then should successfully open Users list page
    And Click on "Accept Guest" button
    And Close screen

  Scenario: Check if guest received invitation email
    Given I'm on the mailinator home page "http://mailinator.com/"
    When I enter guest email from step above
    And Click on Check it button
    Then There is an email with subject "You have been approved as a guest"
    And Close screen

  Scenario: Unselect admin approval checkbox
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.owner@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    Then should successfully open workspaces list page
    When I click on organization settings
    And Unselect checkbox "Guest invites require admin approval"
    Then Alert "Successfully updated guest invite approval settings" will appear on the page
    And Close screen