# frozen_string_literal: true
require 'rails_helper'

RSpec.configure do |config|
  config.before(:each) do
    driven_by(:selenium_remote)
  end
end