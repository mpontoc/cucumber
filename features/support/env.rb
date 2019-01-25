require 'rspec'
require 'cucumber'
require 'capybara'
require 'selenium-webdriver'
require 'capybara/cucumber'

#Capybara::Selenium::Driver.new(app, :browser => :firefox, :marionette => true) -------para firefox

Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
    #Capybara::Selenium::Driver.new(app, :browser => :firefox, :marionette => true)
end

    Capybara.configure do |config|
            config.default_driver = :selenium
            config.app_host = 'http://www.google.com'
    end

