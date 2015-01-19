Feature: Table update
  In order to change a table
  As a user
  I want it to work properly

  Background:
    Given I am a logged user
      And I am on welcome page

  Scenario: Access table menu
    Given One table with status "sala1" exists
      And One table with status "sala2" exists
      And One table with status "producao" exists
     When I check the option "Tabela"
     Then I should see "TA001 MyString", "TA002 MyString" and "TA003 MyString"

  Scenario: Access to table form
     When I click on Tabela button on menu
     Then I should go to "Cadastro de Tabela"

  Scenario: Failed to create table due validations
    Given I am on table form
     When I click to save
     Then I should see all validation errors

  Scenario: Succesfully create table
    Given I am on table form
      And I fill all required fields
     When I click to save
     Then I should be redirect to welcome page with table selected
