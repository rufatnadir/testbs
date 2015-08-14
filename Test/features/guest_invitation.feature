@rufat
@complete
@user
@admin
@ciready
Feature: Guest invitation by user and approve by the org admin

  Scenario: Change User settings by org owner
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "stagtest@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    Then should successfully open workspaces list page
    When I click on organization settings
    And Select checkbox "Guest invites require admin approval"
    And Close screen

  Scenario: Getting to workspace sharing status page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "user.auto@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    And User click Sharing link of the workspace "ShareTest"

  Scenario: Inviting guest to the workspace
    Given I'm on the "Sharing Status" page
    When I'm entering guests email "@mailinator.com" on email field
    And Click on Share button
    Then "Workspace shared to guest pending admin approval" alert appears on top of the page
    And Close screen

  Scenario: Reject guest by admin
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "adm.auto@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    And User click on Users tab
    And User removes pending guest from step above
    And Close screen

  Scenario: Check if invitee received email
    Given I'm on the mailinator home page "http://mailinator.com/"
    When I enter user email "user.auto"
    And Click on Check it button
    Then There is an email with subject "was denied guest access to"
    And Close screen

  Scenario: Getting to workspace sharing status page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "user.auto@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    And User click Sharing link of the workspace "ShareTest"

  Scenario: Inviting guest to the workspace
    When I'm entering guests email "@mailinator.com" on email field
    And Click on Share button
    Then "Workspace shared to guest pending admin approval" alert appears on top of the page
    And Close screen

  Scenario: Approve guest by org admin
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "adm.auto@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    And User click on Users tab
    And User accept pending guest from step above
    And Close screen

  Scenario: Sign in to Bluescape as invited guest
    Given I'm on the mailinator home page "http://mailinator.com/"
    When I enter guest email from step above
    And Click on Check it button
    And I open an email with subject "You have been approved as a guest of TestStage"
    And I click on "ShareTest" link
    Then New tab will open "Welcome to Bluescape"

  Scenario: Sign-up to the Bluescape with invitation
    Given I'm on the Bluescape sign-up page "Welcome to Bluescape"
    When I enter users first name "Invited"
    And I enter users last name "Guest"
    And Enter new password and confirmation "Nr_3181299"
    And Select new industry from the drop-down list "Education"
    And Click Accept invitation button
    Then The workspace "ShareTest" canvas page should load successfully
    And I click on Close tour button
    And Close screen


"""
  Scenario: Reject guest by admin
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "adm.auto@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    And User click on Users tab
    And User removes guest from step above
"""
