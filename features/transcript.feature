Feature: Media Items can have transcriptions
  In order to annotate a media item
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

  @allow-rescue
  Scenario: Private transcript cannot be accessed by another user
   Given a user: "silvia" exists
   And a transcript exists with depositor: user "silvia", private: true
    When I am on that transcript's page
    # TODO Add a proper 404 page
    Then I should see "ActiveRecord::RecordNotFound"

  Scenario: Public transcript can be accessed by another user
   Given a user: "silvia" exists
     And a transcript exists with depositor: user "silvia", private: false
    When I am on that transcript's page
    Then I should see "Link"

  Scenario Outline: Bad transcript doesn't validate
    Given I am on the new transcript page
     When I attach the file "features/test_data/<file>" to "Transcript"
      And I select "<format>" from "Format"
      And I press "Validate"
     Then I should see "Transcript did not validate against the schema"
      And I should see "<error>"

    Examples:
      | file             | format      | error           |
      | elan1.xml        | Toolbox     | No matching global declaration available for the validation root |
      | toolbox1.xml     | Transcriber | No matching global declaration available for the validation root |
      | transcriber1.xml | ELAN        | No matching global declaration available for the validation root |
      | eopas1.xml       | ELAN        | No matching global declaration available for the validation root |

  Scenario: Add participants
    Given a transcript exists with depositor: user "johnf1"
     When I go to that transcript's edit page
      And I fill in "Name" with "John Ferlito" within ".participant"
      And I select "speaker" from "Role" within ".participant"
      And I press "Update"
     Then I should see "Transcript was successfully updated"
      And I should see "John Ferlito" within ".participant"
      And I should see "speaker" within ".participant"
      And I should see "rat, this rat"

  @javascript
  Scenario Outline: Upload valid transcriptions
    Given I am on the new transcript page
     When I attach the file "features/test_data/<file>" to "Transcript"
      And I select "<format>" from "Format"
      And I press "Validate"
     Then I should see "Transcript was successfully validated and added"

     When I fill in "Title" with "<title>"
      And I select "Australia" from "Country Code"
      And I select "Miwa (vmi)" from "Language Code"
      And I press "Update"
     Then I should see "Transcript was successfully updated"
      And I should see "<text>"
      And I should see "<title>"

      And show me the page
     When I follow "EOPAS" within "#metadata_display"
      And I should see "<text>"

    Examples:
      | file             | format      | text           | title         |
      | elan1.xml        | ELAN        | so from here   | ELAN 1        |
      | elan2.xml        | ELAN        | My name is Joe | ELAN 2        |
      | elan3.xml        | ELAN        | Amurin na      | ELAN 3        |
      | elan4.eaf        | ELAN        | Me nai ne      | ELAN 4        |
      | eopas1.xml       | EOPAS       | so from here   | EOPAS 1       |
      | eopas2.xml       | EOPAS       | Endis reading  | EOPAS 2       |
      | eopas3.xml       | EOPAS       | rat, this rat  | EOPAS 3       |
      | toolbox1.xml     | Toolbox     | about this wo  | TOOLBOX 1     |
      | toolbox2.xml     | Toolbox     | about the rat  | TOOLBOX 2     |
      | toolbox3.xml     | Toolbox     | Litrapong      | TOOLBOX 3     |
      | toolbox4.xml     | Toolbox     | ngar-uba-gi    | TOOLBOX 4     |
      | toolbox5.xml     | Toolbox     | ipiatlak       | TOOLBOX 5     |
      | toolbox6.xml     | Toolbox     | murrinh        | TOOLBOX 6     |
      | toolbox7.xml     | Toolbox     | pnuti mees     | TOOLBOX 7     |
      | transcriber1.xml | Transcriber | pause crowd    | TRANSCRIBER 1 |
      | transcriber2.xml | Transcriber | puet soksoki   | TRANSCRIBER 2 |

  @javascript
  Scenario: Attach a media item to a transcript
    Given a transcript exists with title: "Moo", depositor: user "johnf1"
    And a media item exists with original_file_name: "features/test_data/eopas3.xml", depositor: user "johnf1", title: "Cow"

     When I go to that transcript's page
     Then I should see "Link to Media Item"

     When I follow "Link to Media Item"
      And I follow "Attach"
     Then I should be on that transcript's page
      And I should see "Unlink Media Item"

  Scenario: Detach a media item to a transcript
    Given a media item "media" exists with original_file_name: "features/test_data/eopas3.xml", depositor: user "johnf1", title: "Cow"
      And a transcript exists with title: "Moo", depositor: user "johnf1", media_item: media item "media"

     When I go to that transcript's page
     Then I should see "Unlink Media Item"
     When I follow "Unlink Media Item"
     Then I should be on that transcript's page
      And I should see "Link to Media Item"

  Scenario: List of transcripts
    Given a transcript exists with title: "Moo", depositor: user "johnf1"
      And a transcript exists with title: "Cow", depositor: user "johnf1"
     When I am on the home page
      And I follow "Browse Transcripts"
     Then I should see "Moo"
      And I should see "Cow"

  Scenario: Delete a transcript
    Given a transcript exists with title: "Moo", depositor: user "johnf1"
     When I go to that transcript's page
     Then I should see "rat, this rat"
      And 1 transcripts should exist
      And 77 transcript phrases should exist

     When I follow "Delete transcript"
     Then I should see "Transcript deleted"
      And I should not see "EOPAS 3"
      And 0 transcripts should exist
      And 0 transcript phrases should exist
      And 0 transcript words should exist
      And 0 transcript morphemes should exist

  @allow-rescue
  Scenario: I can't delete another users transcript
   Given a user: "silvia" exists
   And a transcript exists with title: "Moo", depositor: user "silvia", private: false
    When I go to that transcript's page
    Then I should see "Moo"
     And I should not see "Delete"

    When I make a DELETE request to that transcript's page
    Then I should see "ActiveRecord::RecordNotFound"


