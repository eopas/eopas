Feature: Website needs static content
  In order to display information
  As an admin
  I want to be able to add static pages


  Scenario: Home Page exists
    When I go to the home page
    Then I should see "EOPAS"

  Scenario: Home Page link goes to homepage
    When I am on the about page
    And  I follow "Home"
    Then I should be on the home page

  Scenario: About Page exists
    When I go to the home page
    And  I follow "About"
    Then I should be on the about page
    And  I should see "About Eopas"

