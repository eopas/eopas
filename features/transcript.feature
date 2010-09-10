Feature: Media Items can have transcriptions
  In order to annot a media item
  As a user
  I want to be able to add transcriptions

  Background:
    Given the application is set up
      And a user: "johnf1" exists
      And I am logged in as the user "johnf1"
      And a media item exists with depositor: user "johnf1"
    When I go to that media item's page
     And I follow "Add transcript"

  Scenario Outline: Bad transcript doesn't vaidate
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
    When I attach the file "features/test_data/<file>" to "Transcript"
     And I select "<format>" from "Format"
     And I press "Add"
    Then I should see "Transcript was successfully added"
     And I should be on that media item's page
     And I should see "<text>"
    When I follow "EOPAS" within "#metadata_display"
    Then I should see "" within "interlinear-text"
     And I should see "<text>"
    When I go to that media item's page
     And I follow "Original"
    Then I should see "<text>"
     And I should see "" within "<format-identifier>"

    Examples:
      | file             | format      | text           | format-identifier   |
      | elan1.xml        | ELAN        | so from here   | annotation_document |
      | elan2.xml        | ELAN        | My name is Joe | annotation_document |
      | eopas1.xml       | EOPAS       | so from here   | eopas               |
      | eopas2.xml       | EOPAS       | cristiana ica  | eopas               |
      | eopas3.xml       | EOPAS       | his father     | eopas               |
      | toolbox1.xml     | Toolbox     | about this wo  | database            |
      | toolbox2.xml     | Toolbox     | about the rat  | database            |
      | transcriber1.xml | Transcriber | pause crowd    | trans               |
      | transcriber2.xml | Transcriber | puet soksoki   | trans               |

