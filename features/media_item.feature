Feature: Media
  In order to utilise transcripts
  As a user
  I want to upload audio and video files

  Background:
    Given the application is set up
      And a user: "johnf1" exists
      And I am logged in as the user "johnf1"
  Scenario: Upload Page exists if logged in
    Given I am on the home page
     When  I follow "Upload Media"
     Then I should be on the new media item page

  Scenario: Can't upload media if not logged in
    Given I am logged out
     When I am on the new media item page
     Then I should be on the login page
      And I should see "You must be logged in to access that page."

  @javascript
  Scenario: Create a new media item Audio
    When I am on the new media item page
     And I attach the file "features/test_data/test.mp3" with full path to "Media"
     And I select "audio" from "Format"
     And I fill in "Title" with "Test Audio"
     And I select "31 March 2010" as the "Recorded on" date
     And I fill in "Copyright Holder" with "John Ferlito"
     And I press "Create"
    Then I should see "Media item was successfully created"

  @javascript
  Scenario: Create a new media item Video
    Given I mock kickvideo for "ffmpeg -i.*-acodec libvorbis.*-vcodec libtheora.*-f ogg.*-y"
      And I mock kickvideo for "ffmpeg -i.*-f image2.*-vcodec png"
    When I am on the new media item page
     And I attach the file "features/test_data/test.m4v" with full path to "Media"
     And I select "video" from "Format"
     And I fill in "Title" with "Test Video"
     And I select "31 March 2010" as the "Recorded on" date
     And I fill in "Copyright Holder" with "John Ferlito"
     And I press "Create"
    Then I should see "Media item was successfully created"
     And there should be 1 delayed job
     And I should see "Test Video"
     And I should see "John Ferlito" within "tr#depositor"
     And I should see "2010-03-31" within "tr#recorded_on"
     And I should see "John Ferlito" within "tr#copyright"
     And I should see "CC-AU-BY-SA" within "tr#license"
     And I should see "false" within "tr#private"
     And I should see the image "missing.png" within "#media_display"
    When I process the delayed jobs
    Then there should be 0 delayed jobs
    When I go to the home page
     And I follow "Browse Media"
    Then I should see "Test Video"
    When I follow "Test Video"
    Then I should not see "Video is being transcoded"

  @allow-rescue
  Scenario: Private video cannot be accessed by another user
   Given a user: "silvia" exists with email: "silvia@doe.com"
     And a media item exists with depositor: user "silvia"
    When I am on that media item's page
    # TODO Add a proper 404 page
    Then I should see "ActiveRecord::RecordNotFound"

  @allow-rescue
  Scenario: I can't delete another users media_items
    Given a user: "silvia" exists with email: "silvia@doe.com"
    And a media item exists with title: "Moo", depositor: user "silvia", private: false
    When I go to that media item's page
    Then I should see "Moo"
     And I should not see "Delete"

    When I make a DELETE request to that media item's page
    Then I should see "ActiveRecord::RecordNotFound"

  @allow-rescue
  Scenario: Need to confirm deletion of my video if media_items are attached to it
    Given a media item "moo" exists with title: "Moo", depositor: user "johnf1"
      And a transcript exists with media_item: media_item "moo", depositor: user "johnf1"
    When I go to that transcript's page
    Then I should see "Media Player"

    When I go to that media item's page
    Then I should see "Moo"

    When I follow "Delete"
    Then I should see "linked to"

    When I follow "Force Delete"
    Then I should see "Media Item and transcript links deleted"

    When I go to that transcript's page
    Then I should see "No media item attached"


