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

  @wip
  Scenario:
    When I validate the transcription "eopas1.xml" as an "eopas" format
    Then the transcription should be valid

  @wip
  Scenario:
    When I transcode the transcription "elan1.xml" as an "elan" format in directory "features/test_data/"
    Then a transcription "e_elan1.xml" should exist in directory "features/test_data/"
