Feature: Import and export transcription files
  In order to import and export transcription files
  As a user
  I want to validate, transcode, import and export transcriptions

  Scenario:
    When I validate the transcription "elan1.xml" as an "elan" format
    Then the transcription should be valid
  
  Scenario:
      When I validate the transcription "elan1.xml" as an "toolbox" format
      Then the transcription should not be valid

  Scenario:
    When I validate the transcription "toolbox1.xml" as an "toolbox" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "transcriber1.xml" as an "transcriber" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "eopas1.xml" as an "eopas" format
    Then the transcription should be valid

  Scenario:
    When I transcode the transcription "elan1.xml" as an "elan" format in directory "features/test_data/"
    Then a transcription "e_elan1.xml" should exist in directory "features/test_data/"

  @wip
  Scenario:
    Given a user: "johnf1" exists
    And I am logged in as the user "johnf1"
    And a media item exists
    When I import the transcription "e_elan1.xml" in directory "features/test_data/" for that media item
    Then a transcript should exist with depositor: user "johnf1" for that media item
    And this transcript has at least 1 transcript tier with at least 1 transcript phrase

