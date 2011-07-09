# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/dsl"

Capybara.default_driver   = :rack_test
Capybara.default_selector = :css
Capybara.app = Rack::Builder.new do
  map "/" do
    run Rails.application
  end
end.to_app

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.mock_with :rspec
  
  # Activate Capybara for integration tests.
  # Cargo culted from rspec-rails
  def config.escaped_path(*parts)
    Regexp.compile(parts.join('[\\\/]'))
  end
  
  config.include Capybara::DSL, :type => :integration, :example_group => {
    :file_path => config.escaped_path(%w[spec integration])
  }
end
