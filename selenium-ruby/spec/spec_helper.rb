# frozen_string_literal: true
require 'rails_helper'

RSpec.configure do |config|
  config.before(:suite) do
    driven_by(:selenium_remote)
  end

  config.after(:suite) do
    # Assuming we need to quit the driver, adjust as necessary
    Capybara.current_session.driver.quit
  end
end