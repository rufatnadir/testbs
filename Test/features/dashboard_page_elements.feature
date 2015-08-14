@rufat
@complete
@user

Feature: Going to Dashboard and checking all expected element on dashboard page are present

  Scenario: Confirm Support link is present
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the userid "automation.org.user@bluescape.com" and password "20sTagi15"
    Then I should be able to login successfully
    When I open "Contact Support" form
    And I select "Problem" from dropdown and type "Some Problem" and "Details of the problem" in corresponding fields
    And Close support form
    And Close screen

  Scenario: Confirm Help link is present
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the userid "automation.org.user@bluescape.com" and password "20sTagi15"
    Then I should be able to login successfully
    And I click on Help link
    Then "Using Bluescape" window will display
    And I click on "Next" button
    And I click on "Next" button
    And I click on "Finished" button
    And Close screen

  Scenario: Confirm Bluescape logo is present
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the userid "automation.org.user@bluescape.com" and password "20sTagi15"
    Then I should be able to login successfully
    And I should see Bluescape logo
    And Highlight Bluescape Logo
    And Close screen



