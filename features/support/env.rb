require 'cucumber/rails'
ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

if ENV['BROWSER']
  Capybara.default_driver = Capybara.javascript_driver = :selenium
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
else
  Capybara.default_driver = Capybara.javascript_driver = :webkit

  require 'headless'
  headless = Headless.new
  headless.start
end
