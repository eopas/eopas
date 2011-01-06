Feature: Media
  In order to utilise transcripts
  As a user
  I want to upload audio and video files

  Background:
    Given the application is set up
      And a user: "johnf1" exists
      And I am logged in as the user "johnf1"
      And I mock paperclip for "ffmpeg -i /tmp/paperclip-reprocess,27297,0 -ar 22050 -ab 64k -async 2 -acodec libvorbis -b 512k -bt 512k -r 30 -threads 0 -vcodec libtheora -padtop 30 -padright 0 -padbottom 30 -padleft 0 -s 320x180 -f ogg -y /tmp/paperclip-reprocess,27297,0-encoded,27297,0"

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
  Scenario: Create a new media item
    When I am on the new media item page
     And I attach the file "features/test_data/test.m4v" with full path to "Media"
     And I fill in "Title" with "Test Video"
     And I select "31 March 2010" as the "media_item_recorded_at" date
     And I fill in "Name of Annotator" with "John Ferlito"
     And I fill in "Name of Participant" with "Random"
     And I fill in "Copyright Holder" with "John Ferlito"
     And I select "Germany" from "Country Code"
     And I select "Korean (kor)" from "Language Code"
     And I press "Create"
    Then I should see "Media item was successfully created"
     And there should be 1 delayed job
     And I should see "eopas_test_0" within "tr#item_id"
     And I should see "Test Video"
     And I should see "John Ferlito" within "tr#depositor"
     And I should see "2010-03-31" within "tr#recorded_at"
     And I should see "John Ferlito" within "tr#annotator_name"
     And I should see "Random" within "tr#participant_name"
     And I should see "speaker" within "tr#participant_role"
     And I should see "kor" within "tr#language_code"
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


#    And   a user: "silvia" exists with email: "silvia@doe.com"
#    And the following videos exist
#      | title            | description      | tags      | video_file_name    |
#      | Test Video One   | one is awesome   | one,uno   | big_buck_bunny.avi |
#      | Test Video Two   | two is awesome   | two,due   | big_buck_bunny.avi |
#      | Test Video Three | three is awesome | three,tre | big_buck_bunny.avi |
#    And the first video is a video of user "john"
#    And the 2nd video is a video of user "john"
#    And the 3rd video is a video of user "silvia"
#    And the following timed_texts exist
#      | category | lang | mime_type | charset | source_file_name   |
#      | SUB      | en   | text/srt  | UTF-8   | big_buck_bunny.srt |
#    And that timed_text is a timed_text for the first video
#

#  Scenario: Video links not visible when logged out
#    Given I am not logged in
#    When I am on the home page
#    Then I should not see "List"
#    Then I should not see "Upload"
#
#  Scenario: Video links are visible when logged in
#    When I am on the home page
#    Then I should see "List"
#    Then I should see "Upload"
#
#  Scenario: Upload Page exists
#    When I am on the home page
#    And  I follow "Upload"
#    Then I should be on the new video page
#
#  Scenario: Link to list of videos exists
#    When I am on the home page
#    And  I follow "List"
#    Then I should be on the videos page
#
#  Scenario: Link to list only visible if logged in
#    Given I am not logged in
#    When I am on the videos page
#    Then I should see "You must be logged in"
#

#  Scenario: Create an invalid video
#    When I am on the new video page
#    And  I press "Upload"
#    Then I should see "Please choose a video to upload"
#    And  I should see "Title can't be blank"
#    And  I should see "Description can't be blank"
#    And  I should see "Tags can't be blank"
#
#  Scenario: Video View Page exists
#    When I am on the videos page
#    Then I should see "Test Video One"
#    And I should see "Test Video Two"
#    And I should not see "Test Video Three"
#
#  Scenario: Click through to individual video page
#    When I am on the videos page
#    And I follow "Test Video One"
#    Then I should be on the first video's page
#
#  Scenario: Video Edit Page exists
#    When I am on the first video's page
#    And  I follow "Edit"
#    Then I should be on the first video's edit page
#
#  Scenario: Change video details
#    Given I am on the first video's edit page
#    When I fill in "Title" with "Improved Test Video one"
#    And I fill in "Description" with "It sucks actually"
#    And I fill in "Tags" with "suckage,moo"
#    And I press "Update"
#    Then I should be on the first video's page
#    And I should see "Video was successfully updated"
#    And I should see "Improved Test Video one"
#    And I should see "It sucks actually"
#    And I should see "suckage,moo"
#
#  Scenario: You can view a video with subtitles
#    When I am on the first video's page
#    Then I should see "Test Video One"
#    And I should see "one is awesome"
#    And I should see "one,uno"
#    And I should not see "Test Video Two"
#    And I should see "text/srt"
#    And I should see "itext" in the raw HTML
#    And I should see "URL:"
#    And I should see "Embed:"
#
#  @allow-rescue
#  Scenario: I Can't view another users videos
#    When I am on the 3rd video's page
#    Then I should see "Sorry, the page you were looking for does not exist."
#
#  Scenario: Delete video successfully
#    When I am on the first video's page
#    And  I follow "Delete"
#    Then I should see "Video deleted!"
#
#  Scenario: Delete video confirmation dialog
#    When I am on the first video's page
#    Then I should see "Do you really want to delete this video" in the raw HTML
#
