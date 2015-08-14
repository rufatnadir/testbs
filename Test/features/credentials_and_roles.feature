@sal
@complete
@owner @user @admin

Feature: Testing the different types of Bluescape users based on their roles and the login credentials


  Scenario Outline: log into workspace successfully
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the user id <user_id> and password <password>
    Then I should be able to login successfully
    And Role should be <role> in user account pop up
    And Close screen
  Examples:
    | user_id                            |  password       |  role                      |
    | automation.org.owner@bluescape.com |  20sTagi15      |  Account Owner             |
    | automation.org.admin@bluescape.com |  20sTagi15      |  Administrator             |
    | automation.org.user@bluescape.com  |  20sTagi15      |  User                      |

  Scenario Outline: Fail to log into workspace successfully
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the user id <user_id> and password <password>
    Then I should not be able to login
    And Close screen
  Examples:
    | user_id                            |  password      |  role                      |
    | automation.org.owner@bluescape.com |  dutoboho      |  Account Owner             |
    | automation.org.admin@bluescape.com |  12312414      |  Administrator             |
    | automation.org.user@bluescape.com  |  #%#&#sdf      |  User                      |

  Scenario Outline: Confirm Organization Settings only accessible by the account Owner
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the user id <user_id> and password <password>
    Then I should be able to login successfully
    Given The user click the Organization link "Enterprise Test"
    Then <role> ability to see Organization Settings should be <organization_settings_accessibility>
    And Close screen
  Examples:
    | user_id                            |  password       |  role                      | organization_settings_accessibility            |
    | automation.org.owner@bluescape.com |  20sTagi15      |  Account Owner             | enabled                                        |
    | automation.org.admin@bluescape.com |  20sTagi15      |  Administrator             | not enabled                                    |
    | automation.org.user@bluescape.com  |  20sTagi15      |  User                      | not enabled                                    |

  Scenario Outline: Try to log in with invalid emails and fail
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the correct the user id <user_id> and password <password>
    Then I should not be able to login
    And Close screen
  Examples:
    | user_id                               |  password        |  role                      |
    | aasdfasdfasdfasdfner@gmail.com        |  20sTagi15       |  Account Owner             |
    | automation.org.admin@gmail.com        |  20sTagi15       |  Administrator             |
    | 11111111111@blueasape.com             |  20sTagi15       |  User                      |
    |AutomationTestUserBluescape@gmail.com  |  20sTagi15       |  User                      |
