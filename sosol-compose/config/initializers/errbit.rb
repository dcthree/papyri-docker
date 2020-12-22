Airbrake.configure do |config|
  config.host = 'https://errbit-dc3.herokuapp.com'
  config.project_id = 1 # required, but any positive integer works
  config.project_key = '2dacf6b2c62f2073bc14786504789294'
  # config.performance_stats = false

  # Uncomment for Rails apps
  config.environment = Rails.env
  # config.ignore_environments = %w(development test)
end
