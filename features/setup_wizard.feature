Feature: Initial Application Setup
  In order to setup the applications
  As the installer
  I want to enter the setup configuration

  Scenario: Redirect to setup page
    Given I go to the home page
    Then I should be on the new admin setup wizard page

  Scenario: Set up the application
    Given I am on the new admin setup wizard page
    When I fill in "First name" with "John"
    When I fill in "Last name" with "Ferlito"
    When I fill in "Email" with "johnf@inodes.org"
     And I fill in "Password" with "moocow"
     And I fill in "Password confirmation" with "moocow"
     And I press "Finish"
    Then I should be on the homepage
     And I should see "The site has been set up and the admin user created - please log in."
    When I follow "Login"
    When I fill in "Email" with "johnf@inodes.org"
     And I fill in "Password" with "moocow"
    Then I press "Login"
    Then I should see "John Ferlito"

  Scenario: A setup application doesn't allow you to set it up
    Given the application is set up
      And I am on the new admin setup wizard page
     Then I should be on the home page
