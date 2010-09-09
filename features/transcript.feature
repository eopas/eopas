Feature: Media Items can have transcriptions
  In order to annot a media item
  As a user
  I want to be able to add transcriptions

  Background:
    Given the application is set up
      And a user: "johnf1" exists
      And I am logged in as the user "johnf1"
      And a media item exists with depositor: user "johnf1"


  Scenario: Bad transcript doesn't vaidate
    When I go to that media item's page
     And I follow "Add transcript"
     And I attach the file "features/test_data/elan1.xml" to "Transcript"
     And I select "Toolbox" from "Format"
     And I press "Add"
    Then I should see "Transcript did not validate against the schema"
     And I should see "No matching global declaration available for the validation root"

  @wip
  Scenario: Add a transcription to a media item
    When I go to that media item's page
     And I follow "Add transcript"
     And I attach the file "features/test_data/elan1.xml" to "Transcript"
     And I select "ELAN" from "Format"
     And I press "Add"
    Then I should see "Transcript was successfully added"
     And I should be on that media item's page
     And I should see "so from here"

