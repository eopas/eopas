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

    Examples:
      | file             | format      | text           |
      | elan1.xml        | ELAN        | so from here   |
      | elan2.xml        | ELAN        | My name is Joe |
      | eopas1.xml       | EOPAS       | so from here   |
      | eopas2.xml       | EOPAS       | cristiana ica  |
      | eopas3.xml       | EOPAS       | his father     |
      | toolbox1.xml     | Toolbox     | about this wo  |
      | toolbox2.xml     | Toolbox     | about the rat  |
      | transcriber1.xml | Transcriber | pause crowd    |
      | transcriber2.xml | Transcriber | puet soksoki   |

