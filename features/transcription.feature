Feature: Import and export transcription files
  In order to import and export transcription files
  As a user
  I want to validate, transcode, import and export transcriptions

# VALIDATION TESTS
#
  Scenario:
    When I validate the transcription "elan1.xml" as an "elan" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "elan2.xml" as an "elan" format
    Then the transcription should be valid

  Scenario:
      When I validate the transcription "elan1.xml" as an "toolbox" format
      Then the transcription should not be valid

  Scenario:
    When I validate the transcription "toolbox1.xml" as an "toolbox" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "toolbox2.xml" as an "toolbox" format
    Then the transcription should be valid

  Scenario:
      When I validate the transcription "toolbox1.xml" as an "transcriber" format
      Then the transcription should not be valid

  Scenario:
    When I validate the transcription "transcriber1.xml" as an "transcriber" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "transcriber2.xml" as an "transcriber" format
    Then the transcription should be valid

  Scenario:
      When I validate the transcription "transcriber1.xml" as an "elan" format
      Then the transcription should not be valid

  Scenario:
    When I validate the transcription "eopas1.xml" as an "eopas" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "eopas2.xml" as an "eopas" format
    Then the transcription should be valid

  Scenario:
    When I validate the transcription "eopas3.xml" as an "eopas" format
    Then the transcription should be valid

  Scenario:
      When I validate the transcription "eopas1.xml" as an "elan" format
      Then the transcription should not be valid

# TRANSCODING TESTS
#
  Scenario:
    When I transcode the transcription "elan1.xml" as an "elan" format in directory "features/test_data/"
    Then a transcription "e_elan1.xml" should exist in directory "features/test_data/"

  Scenario:
    When I transcode the transcription "transcriber1.xml" as an "elan" format in directory "features/test_data/"
    Then a transcription "e_transcriber1.xml" should not exist in directory "features/test_data/"

  Scenario:
    When I transcode the transcription "transcriber1.xml" as an "transcriber" format in directory "features/test_data/"
    Then a transcription "e_transcriber1.xml" should exist in directory "features/test_data/"

  Scenario:
    When I transcode the transcription "toolbox1.xml" as an "toolbox" format in directory "features/test_data/"
    Then a transcription "e_toolbox1.xml" should exist in directory "features/test_data/"

  Scenario:
    When I transcode the transcription "eopas1.xml" as an "eopas" format in directory "features/test_data/"
    Then a transcription "e_eopas1.xml" should exist in directory "features/test_data/"

# IMPORT TESTS
#
  Scenario:
    Given a user: "johnf1" exists
    And I am logged in as the user "johnf1"
    And a media item exists
    When I import the transcription "eopas1.xml" in directory "features/test_data/" for that media item
    Then a transcript should exist with depositor: user "johnf1" for that media item
    And this transcript has at least 1 transcript tier with at least 1 transcript phrase

  Scenario:
    Given a user: "johnf1" exists
    And I am logged in as the user "johnf1"
    And a media item exists
    When I import the transcription "eopas2.xml" in directory "features/test_data/" for that media item
    Then a transcript should exist with depositor: user "johnf1" for that media item
    And this transcript has at least 1 transcript tier with at least 1 transcript phrase

  Scenario:
    Given a user: "johnf1" exists
    And I am logged in as the user "johnf1"
    And a media item exists
    When I import the transcription "eopas3.xml" in directory "features/test_data/" for that media item
    Then a transcript should exist with depositor: user "johnf1" for that media item
    And this transcript has at least 1 transcript tier with at least 1 transcript phrase

# EXPORT TESTS
#
