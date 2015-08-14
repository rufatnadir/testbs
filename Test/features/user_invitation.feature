@rufat
@complete
@admin
@ciready

Feature: User receives invitation to organization and registers on Bluescape

  Scenario: Getting to users list page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.admin@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    And User click on Users tab
    Then should successfully open Users list page

  Scenario: Inviting user by email
    Given I'm an organization owner on Users list
    When I click on New User button
    Then Browser takes me to "Add New Users" page
    When I enter new user "@mailinator.com" on field
    And Click "Add Users" button
    Then Alert will be displayed
    And Close screen

  Scenario: Open invitation link
    Given I'm on the mailinator home page "http://mailinator.com/"
    When I enter user email from step above
    And Click on Check it button
    Then I open an email with subject "Invitation to Bluescape"
    When I click on invitation link
    Then New tab will open "Welcome to Bluescape"

  Scenario: Sign-up to the Bluescape with invitation
    Given I'm on the Bluescape sign-up page "Welcome to Bluescape"
    When I enter users first name "User"
    And I enter users last name "ToDelete"
    And Enter new password and confirmation "Nr_3181299"
    And Select new industry from the drop-down list "Communications"
    And Click Accept invitation button
    Then "Using Bluescape" window will display
    When I click on "Get Started" button
    And I click on "Next" button
    And I click on "Next" button
    And I click on "Finished" button
    Then I should be able to login successfully
    And Close screen

  Scenario: Removing user from organization
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "automation.org.admin@bluescape.com"
    And User enters the password "20sTagi15"
    And User Click Sign In button
    And The user click the Organization link "Enterprise Test"
    And User click on Users tab
    Then should successfully open Users list page
    When Select "User ToDelete" from list and click edit button
    And Remove user from organization
    Then "Successfully removed" alert appears on top of the page
    And Close screen

  Scenario: Verify user removed from org
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters invited user email
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    Then User will successfully login to Bluescape
    And "No Organizations Found" message will display
    And Close screen


