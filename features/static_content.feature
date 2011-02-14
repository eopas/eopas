Feature: Website needs static content
  In order to display information
  As an admin
  I want to be able to add static pages

  Background:
    Given the application is set up

  Scenario: Home Page exists
    When I go to the home page
    Then I should see "EOPAS"

  Scenario: Home Page link goes to homepage
    When I am on the help page
    And  I follow "Home"
    Then I should be on the home page

  Scenario: Help Page exists
    When I go to the home page
    And  I follow "Help"
    Then I should be on the help page
    And  I should see "Help for EOPAS"

