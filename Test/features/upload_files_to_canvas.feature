@rufat @complete
@admin
@ciready

Feature: Uploading files to the workspace

  Scenario: Upload image and PDF file to the workspace
    Given I am on the "login" page with "https://staging.portal.bluescape.com" url
    When User enters the user id "stag101@mailinator.com"
    And User enters the password "Nr_3181299"
    And User Click Sign In button
    Then should successfully open workspaces list page
    When Create workspace "UploadFilesToDelete"
    When I click on a workspace link "UploadFilesToDelete"
    And Upload image "test_automation/Test/Images/big-hero-6.jpeg" to the workspace
    Then Image will be uploaded on canvas
    When Upload file "test_automation/Test/Images/2012Camry.pdf" to the workspace
    Then File will be uploaded to the canvas
    And User clicks Exit workspace button on the canvas
    And User archives the workspace "UploadFilesToDelete"
    And Close screen
