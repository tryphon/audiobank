Feature: Manage Users
  In order to use AudioBank
  the user
  wants to manage his account

  Scenario: Sign up
    Given I am on the "signup" page
    And I fill in "user_username" with "test"
    And I fill in "user_email" with "test@tryphon.eu"
    And I fill in "user_name" with "Test User"
    And I fill in "Mot de passe" with "secret"
    When I press "Creer un compte"
    Then I should see "Un email de confirmation vous a été envoyé"

  Scenario: Confirm an account
    Given an unconfirmed user exists with username: "test"
    When I am on the user's confirmation page
    Then I should see "Bienvenue"
    And a user should exist with username: "test", confirmed: true 

  Scenario: Sign in
    Given a confirmed user exists with username: "test", password: "secret"
    And I am on the "signin" page
    And I fill in "user_username" with "test"
    And I fill in "Mot de passe" with "secret"
    When I press "Se connecter"
    Then I should see "Bienvenue"

  Scenario: Recover password
    Given a confirmed user exists with username: "test", email: "test@tryphon.eu"
    And I am on the "recover_password" page
    And I fill in "Votre Email" with "test@tryphon.eu"
    When I press "Envoyer"
    Then I should see "Votre nouveau de passe a été envoyé à test@tryphon.eu"
