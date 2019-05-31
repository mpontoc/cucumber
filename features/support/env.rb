require 'rspec'
require 'cucumber'
require 'selenium/webdriver'
require 'capybara/dsl'
require 'site_prism'

World Capybara::DSL
BROWSER = 'remote'

if BROWSER == 'remote'
  Capybara.default_driver = :headless_chrome
  Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(args: 
      %w[no-sandbox headless disable-gpu disable-dev-shm-usage])
      Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

elsif BROWSER == 'firefox'
  Capybara.default_driver = :selenium_firefox
  Capybara.register_driver :selenium_firefox do |app|
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :marionette => true)
  end

else
  Capybara.default_driver = :selenium_chrome
  Capybara.register_driver :selenium_chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end
