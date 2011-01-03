Feature: Media Items can have transcriptions
  In order to annot a media item
  As a user
  I want to be able to add transcriptions

  Background:
    Given the application is set up
      And a user: "johnf1" exists
      And I am logged in as the user "johnf1"

  Scenario: Upload transcript page exists if logged in
    Given I am on the home page
      And I follow "Upload Transcript"
     Then I should be on the new transcript page

  Scenario: Can't upload transcript if not logged in
    Given I am logged out
     When I am on the new transcript page
     Then I should be on the login page
      And I should see "You must be logged in to access that page."

  Scenario Outline: Bad transcript doesn't vaidate
    Given I am on the new transcript page
     When I attach the file "features/test_data/<file>" to "Transcript"
      And I select "<format>" from "Format"
      And I press "Add"
     Then I should see "Transcript did not validate against the schema"
      And I should see "<error>"

    Examples:
      | file             | format      | error           |
      | elan1.xml        | Toolbox     | No matching global declaration available for the validation root |
      | toolbox1.xml     | Transcriber | No matching global declaration available for the validation root |
      | transcriber1.xml | ELAN        | No matching global declaration available for the validation root |
      | eopas1.xml       | ELAN        | No matching global declaration available for the validation root |


  Scenario Outline: Upload valid transcriptions
    Given I am on the new transcript page
     When I attach the file "features/test_data/<file>" to "Transcript"
      And I select "<format>" from "Format"
      And I fill in "Title" with "<title>"
      And I press "Add"
     Then I should see "Transcript was successfully added"
      And I should see "<text>"
     When I follow "EOPAS" within "#metadata_display"
     Then I should see "" within "interlinear"
      And I should see "<text>"
    Given I go back
     When I follow "Original"
     Then I should see "<text>"
      And I should see "" within "<format-identifier>"

    Examples:
      | file             | format      | text           | format-identifier   | title         |
      | elan1.xml        | ELAN        | so from here   | annotation_document | ELAN 1        |
      | elan2.xml        | ELAN        | My name is Joe | annotation_document | ELAN 1        |
      | eopas1.xml       | EOPAS       | so from here   | eopas               | EOPAS 1       |
      | eopas2.xml       | EOPAS       | cristiana ica  | eopas               | EOPAS 1       |
      | eopas3.xml       | EOPAS       | rat, this rat  | eopas               | EOPAS 1       |
      | toolbox1.xml     | Toolbox     | about this wo  | database            | TOOLBOX 1     |
      | toolbox2.xml     | Toolbox     | about the rat  | database            | TOOLBOX 1     |
      | transcriber1.xml | Transcriber | pause crowd    | trans               | TRANSCRIBER 1 |
      | transcriber2.xml | Transcriber | puet soksoki   | trans               | TRANSCRIBER 1 |

  Scenario: List of transcripts
    Given a transcript exists with title: "Moo", depositor: user "johnf1"
      And a transcript exists with title: "Cow", depositor: user "johnf1"
     When I am on the home page
      And I follow "Browse Transcripts"
     Then I should see "Moo"
      And I should see "Cow"

  Scenario: Delete a transcript
    Given I am on the new transcript page
     Then 0 transcripts should exist
      And 0 transcript tiers should exist
      And 0 transcript phrases should exist
     When I attach the file "features/test_data/eopas3.xml" to "Transcript"
      And I select "EOPAS" from "Format"
      And I fill in "Title" with "EOPAS 3"
      And I press "Add"
     Then I should see "Transcript was successfully added"
      And I should see "EOPAS 3"
      And I should see "rat, this rat"
      And 1 transcripts should exist
      And 2 transcript tiers should exist
      And 154 transcript phrases should exist
     When I follow "Delete transcript"
     Then I should see "Transcript deleted"
      And I should not see "EOPAS 3"
      And 0 transcripts should exist
      And 0 transcript tiers should exist
      And 0 transcript phrases should exist


