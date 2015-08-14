@rufat
@complete
@owner

Feature: Select different plans and check their benefits

Scenario Outline:
  Given I am on the "login" page with "https://staging.portal.bluescape.com" url
  When User enters the user id "kqettowner@mailinator.com"
  And User enters the password "Nr_3181299"
  And User Click Sign In button
  When I click on organization settings
  And I click on Upgrade to paid plan button
  Then Plan upgrade page with header "Select your Bluescape plan" displayed
  When I select "<plan>" plan
  Then Total plan cost "<monthly_cost>" will display
  And "<plan>" Benefits are "<storage_limit>", "<workspaces_limit>" and "<users_limit>"
  And Close screen

Examples:
    | plan          | monthly_cost    | storage_limit    | workspaces_limit    | users_limit                |
    | starter       | $11.99          | 3 GB of storage  | 2 workspaces        | 3 additional contributors  |
    | plus          | $34.99          | 15 GB of storage | 8 workspaces        | 10 additional contributors |
    | professional  | $79.99          | 75 GB of storage | 20 workspaces       | 30 additional contributors |
