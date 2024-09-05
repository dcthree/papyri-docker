require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :selenium_remote do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1400,1400")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")  
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = 8
  client.read_timeout = 8
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: 'http://selenium:4444/wd/hub',
    options: options,
    http_client: client
  )
end

Capybara.default_driver = :selenium_remote
Capybara.javascript_driver = :selenium_remote