require 'rspec'
require 'cucumber'
require 'selenium/webdriver'
require 'capybara/dsl'


World Capybara::DSL
BROWSER = ENV['remote']

Capybara.default_driver = :selenium_chrome

if BROWSER.eql?('remote')
  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app,
      :browser => :remote,
      :desired_capabilities => :chrome,
      :url => "http://www.google.com"
    )
  end
else
  Capybara.register_driver :selenium_chrome do |app|
    #Capybara::Selenium::Driver.new(app, :browser => :chrome)
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :marionette => true)
  end
end
