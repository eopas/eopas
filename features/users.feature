Feature: Authentication and Authorisation
  In order to interact with the website
  As a user
  I want to be able to login

  Background:
    Given the application is set up

  Scenario: A Register link should exist
    When I go to the homepage
    Then I should see "Register"

  Scenario: Register an account, confirm it via email and login
    When I go to the homepage
    And I follow "Register"
    Then I should see "Email"
    When I fill in "Email" with "johnf@inodes.org" within "#email"
    And I fill in "First name" with "John"
    And I fill in "Last name" with "Ferlito"
    And I fill in "Password" with "moocow"
    And I fill in "Password confirmation" with "moocow"
    And I press "Register" within "form"
    Then I should see "Thanks for signing up. Please check your email to confirm your account."
    And 1 email should be delivered
    And that email should contain "confirm"
    When I follow "confirm" in that email
    Then I should see "Your account has been activated"
    And I should see "John Ferlito"
    And I should see "Logout"
    And show me the page
    When I follow "Logout"
    And I follow "Login"
    And I fill in "Email" with "johnf@inodes.org"
    And I fill in "Password" with "moocow"
    And I press "Login"
    Then I should see "John Ferlito" within "#login_info"

  Scenario: Login doesn't work after registration without confirmation
    When I go to the homepage
    And I follow "Register"
    Then I should see "Email"
    When I fill in "Email" with "john@inodes.org"
    And I fill in "First name" with "John"
    And I fill in "Last name" with "Ferlito"
    And I fill in "Password" with "moocow"
    And I fill in "Password confirmation" with "moocow"
    And I press "Register"
    Then I should see "Thanks for signing up"
    And I should not see "Logout"
    When I follow "Login"
    And I fill in "Email" with "john@inodes.org"
    And I fill in "Password" with "moocow"
    And I press "Login"
    Then I should see "Your account is not confirmed"

  Scenario: Login and view user page
    Given a user exists with email: "john@inodes.org", password: "moocow"
    When I go to the homepage
    And I follow "Login"
    And I fill in "Email" with "john@inodes.org"
    And I fill in "Password" with "moocow"
    And I press "Login"
    Then I should be on that user's page
    And I should see "Login successful"
    And I should see "John Ferlito" within "#login_info"
    And I should see "John Ferlito" within "#user_details"
    And I should see "Logout" within "#login_info"
    But I should not see "Login" within "#login_info"
    And I should not see "Register" within "#login_info"

  Scenario: Log out
    Given a user exists
    And I am logged in as that user
    When I go to the homepage
    Then I should see "Logout"
    And I follow "Logout"
    Then I should see "Logout successful!"
    And I should be on the homepage

  Scenario: I can logout if I'm already logged out
    When I go to the logout page
    Then I should see "You are already logged out"

  Scenario: Reset password
    Given a user exists with email: "johnf@inodes.org", password: "moocow"
    When I go to the homepage
    And I follow "Login"
    And I follow "Forgot your password?"
    And I fill in "Email" with "johnf@inodes.org"
    And I press "Reset my password"
    Then I should be on the homepage
    And I should see "Please check your email"
    And 1 email should be delivered
    And that email should contain "forgotten_passwords"
    When I follow "forgotten_passwords" in that email
    Then I should see "Change My Password"
    And I fill in "Password" with "foobar"
    And I fill in "Password confirmation" with "foobar"
    And I press "Reset my password and log me in"
    Then I should be on that user's page
    And I should see "John"
    When I follow "Logout"
    And I follow "Login"
    And I fill in "Email" with "johnf@inodes.org"
    And I fill in "Password" with "foobar"
    And I press "Login"
    Then I should see "John"

  Scenario: Must be logged in to show a users page
    Given a user exists with email: "johnf@inodes.org", first_name: "John"
    When I go to that user's page
    Then I should not see "John"
    And I should see "You must be logged in to access that page"

  Scenario: Edit user details
    Given a user exists with email: "john@inodes.org", password: "moocow"
    When I go to the homepage
    And I follow "Login"
    And I fill in "Email" with "john@inodes.org"
    And I fill in "Password" with "moocow"
    And I press "Login"
    Then I should be on that user's page
    And I follow "Edit Details"
    Then I should be on that user's edit page
    And I fill in "First name" with "fred"
    And I fill in "Last name" with "freddo"
    And I fill in "Email" with "fred@freddo.org"
    And I fill in "Change password" with "fredfred"
    And I fill in "Password confirmation" with "fredfred"
    And I press "Update"
    Then I should be on that user's page
    And I should see "fred freddo" within "#login_info"
    And I should see "fred@freddo.org" within "#user_details"
    And I should see "Your account details have been updated, including password."


# This works but allow-rescue is broken in cucumber-rails
#  @allow-rescue
#  Scenario: A user can only see her own details
#    Given a user: "johnf" exists with email: "johnf@inodes.org", first_name: "John"
#    And a user: "silvia" exists with email: "silvia@gingertech.net", first_name: "Silvia"
#    And I am logged in as user "silvia"
#    When I go to the user "silvia"'s page
#    Then I should see "Silvia" within "#content"
#    When I go to the user "johnf"'s page
#    Then I should not see "John" within "#content"
#    And I should see "Sorry, the page you were looking for does not exist."

