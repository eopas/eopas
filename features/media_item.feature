Feature: Media
  In order to utilise transcripts
  As a user
  I want to upload audio and video files
  Background:
    Given a user: "johnf" exists with email: "johnf@inodes.org", first_name: "John", last_name: "Ferlito"
      And I am logged in as the user "johnf"

  Scenario: Upload Page exists if logged in
    When I am on the home page
    And  I follow "Upload"
    Then I should be on the new media item page

  Scenario: Can't upload media if not logged in
    Given I am logged out
    When I am on the new media item page
    Then I should be on the login page
     And I should see "You must be logged in to access that page."

  Scenario: Create a new media item
    When I am on the new media item page
    #And I attach the file "features/assets/big_buck_bunny_720p_surround.avi" to "Video"
    And I fill in "Title" with "Test Video"
    And  I press "Create"
    Then I should see "Media item was successfully created"
     And I should see "Test Video" within "#title"
     And I should see "John Ferlito" within "#depositor"
    When I go to the media items page
    Then I should see "Test Video"
    #Then I should see "Video is being transcoded"
    #When I process the delayed jobs
    #And I go to the videos page
    #And I follow "A test video"
    #Then I should not see "Video is being transcoded"


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