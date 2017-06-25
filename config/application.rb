require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BookStore
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # config.i18n.default_locale = :'en'
    config.middleware.use I18n::JS::Middleware

    ISO3166.configure do |config|
      config.locales = [:en, :gb, :ua]
    end

    config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
      # address: 'smtp.mailgun.org',
      # port: 587,
      # domain: 'app2e789712b1534af188bcb839ad15d822.mailgun.org',
      # authentication: 'plain',
      # enable_starttls_auto: true,
      # user_name: 'postmaster@app2e789712b1534af188bcb839ad15d822.mailgun.org',
      # password: 'd51d97fe22de10bb324a995fdda62126'
    # }
    config.action_mailer.smtp_settings = {
      address: 'smtp.mailgun.org',
      port: 587,
      domain: 'https://api.mailgun.net/v3/sy.bookstore.com',
      authentication: 'plain',
      enable_starttls_auto: true,
      user_name: 'postmaster@sy.bookstore.com',
      password: '56e8a3acceaa11703ae5154c944aad1a'
    }
  end
end
