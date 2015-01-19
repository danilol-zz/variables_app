Feature: Administrator authentication
  In order to manage content
  As an room1 or room2 user
  I want to login to VariablesApp

  Scenario: Login with invalid credentials
    Given I'm on the initial page
     When I try to login with invalid credentials
     Then I should not be logged

  Scenario: Login with valid credentials
    Given I'm a valid user
      And I'm on the initial page
     When I try to login with valid credentials
     Then I should be granted access to VariablesApp

  Scenario: Successfully logout
    Given I am a logged user
     When I click to logout
     Then I should not be logged

