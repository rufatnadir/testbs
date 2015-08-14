@rufat
@incomplete
@owner

Feature: Open users page

  Scenario: Getting to workspace sharing status page
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "stagtest@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    And The user click the Organization link "TestStage"
    And User click on Users tab
    And User removes all pending guests