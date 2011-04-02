Feature: Media Items should have transcriptions
  In order to annotate a media item
  As a user
  I want to be able to add transcriptions

  Background:
    Given the application is set up
      And a user: "johnf" exists
      And a user: "silvia" exists with first_name: "Silvia", last_name: "Pfeiffer", email: "silvia@robotparade.com.au"
      And an admin user: "admin" exists
      And a transcript: "private" exists with depositor: user "johnf", title: "Private Transcript", private: true
      And a transcript: "public" exists with depositor: user "johnf", title: "Public Transcript", private: false

  Scenario: When John logs in he should see everything
    When I am logged in as user: "johnf"
     And I go to the transcripts page
    Then I should see "Private Transcript"
     And I should see "Public Transcript"
    When I follow "Private Transcript"
    Then I should see "Private Transcript" within "#metadata_display"
    When I go to the transcripts page
     And I follow "Public Transcript"
    Then I should see "Public Transcript" within "#metadata_display"

  Scenario: A normal user can't see delayed_jobs_page
    Given I am logged in as user: "silvia"
     When I go to the delayed job admin page
     Then I should not see "attempts"

  Scenario: An admin user can see delayed_jobs_page
    Given I am logged in as user: "silvia"
     When I go to the delayed job admin page
     Then I should see "attempts"

  @allow-rescue
  Scenario: When Silvia logs in she should see public only
    When I am logged in as user: "silvia"
      And I go to the transcripts page
     Then I should not see "Private Transcript"
      And I should see "Public Transcript"
     When I follow "Public Transcript"
     Then I should see "Public Transcript" within "#metadata_display"
     When I go to the transcript: "private"'s page
     Then I should see "ActiveRecord::RecordNotFound"

  @allow-rescue
  Scenario: When Anonymous logs in she should see public only and have to agree
    When I go to the home page
     And I follow "Browse Transcripts"
    Then I should see "By clicking here I agree that I will not contravene this licence."
    When I check "agree"
     And I press "Submit"
    Then I should not see "Private Transcript"
     And I should see "Public Transcript"
    When I follow "Public Transcript"
    Then I should see "Public Transcript" within "#metadata_display"
    When I go to the transcript "private" page
    Then I should see "ActiveRecord::RecordNotFound"


