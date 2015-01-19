Given(/^I am on welcome page$/) do
  visit root_path
end

Given(/^I am on table form$/) do
  visit new_table_path
end

When(/^I check the option "(.*?)"$/) do |entity|
  choose("status04")
end

Given(/^One table with status "(.*?)" exists$/) do |status|
  FactoryGirl.create(:table, status: status.downcase)
end

Then(/^I should see "(.*?)", "(.*?)" and "(.*?)"$/) do |str1, str2, str3|
  expect(page).to have_content str1
  expect(page).to have_content str2
  expect(page).to have_content str3
end

When(/^I click on Tabela button on menu$/) do
  click_link "new_table"
end

Then(/^I should go to "(.*?)"$/) do |str|
  expect(page).to have_content str
end

When(/^I click to save$/) do
  click_button('Salvar')
end

Then(/^I should see all validation errors$/) do
  expect(page).to have_content "Chave não pode ser vazio!"
  expect(page).to have_content "Tipo não pode ser vazio!"
  expect(page).to have_content "Tipo deve ser seleção, colagem, lookup interna, lookup externa, lookup blindagem"
end

Given(/^I fill all required fields$/) do
  select('colagem', :from => 'table_table_type')
  fill_in('table_table_key', with: 'table_test_key')
  fill_in('table_logic_table_name', with: 'table_test_name')
end

Then(/^I should be redirect to welcome page with table selected$/) do
  expect(page).to have_content "TA001 table_test_name"
end
