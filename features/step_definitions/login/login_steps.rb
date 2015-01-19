# -*- encoding: utf-8 -*-
Given(/^I'm a valid user$/) do
  FactoryGirl.create(:user, name: 'jose', email: 'jose@itau.com.br', profile: 'sala1', password: "123456")
end

Given(/^I'm on the initial page$/) do
  visit root_path
end

Given(/^I am a logged user$/) do
  FactoryGirl.create(:user, name: 'jose', email: 'jose@itau.com.br', profile: 'sala1', password: "123456")
  visit login_path
  fill_in "user_email", with: 'jose@itau.com.br'
  fill_in "user_password", with: "123456"
  click_button "Entrar"
end

When(/^I try to login with valid credentials$/) do
  visit login_path
  fill_in "user_email", with: 'jose@itau.com.br'
  fill_in "user_password", with: "123456"
  click_button "Entrar"
end

When(/^I try to login with invalid credentials$/) do
  visit login_path
  fill_in "user_email", with: 'invalid@itau.com.br'
  fill_in "user_password", with: "123456"
  click_button "Entrar"
end

When(/^I click to logout$/) do
  visit logout_path
end

Then(/^I should be granted access to VariablesApp$/) do
  expect(page).to have_content "Olá"
end

Then(/^I should not be logged$/) do
  expect(page).to have_content "Faça o login para entrar no sistema, por favor."
end
