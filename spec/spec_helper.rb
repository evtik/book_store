require 'simplecov'
SimpleCov.start

require 'rails_helper'
require 'capybara/rspec'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'factory_girl_rails'
require 'rack_session_access/capybara'
require 'carrierwave/test/matchers'
require 'rectify/rspec'
require 'wisper/rspec/matchers'
require_relative 'support/database_cleaner'
require_relative 'support/factory_girl'

Dir[Rails.root.join('spec/**/shared_examples/*.rb')].each do |file|
  require file
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    browser: :phantomjs,
    window_size: [1280, 1024],
    js_errors: true,
    debug: false
  )
end

Capybara.current_driver = :poltergeist

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around :each, type: :feature do |example|
    if example.metadata[:use_selenium]
      saved_driver = Capybara.current_driver
      Capybara.current_driver = :selenium
    end

    example.run

    Capybara.current_driver = saved_driver if example.metadata[:use_selenium]
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  config.include CarrierWave::Test::Matchers
  config.include Rectify::RSpec::Helpers
  config.include Wisper::RSpec::BroadcastMatcher
  config.include Rails.application.routes.url_helpers
end
