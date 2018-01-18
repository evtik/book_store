source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '~> 2.3.0'
gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'sprockets-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'

gem 'aasm'
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'cancancan'
gem 'carrierwave', '~> 1.0'
gem 'countries', require: 'countries/global'
gem 'devise'
gem 'draper', '3.0.0.pre1'
gem 'draper-cancancan'
gem 'faker'
gem 'fog-aws'
gem 'hamlit'
gem 'hamlit-rails'
gem 'i18n-js'
gem 'kaminari'
gem 'mini_magick'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'rails-i18n'
gem 'rectify'
gem 'redcarpet'
gem 'virtus'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'launchy'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers',
      git: 'https://github.com/thoughtbot/shoulda-matchers.git',
      branch: 'rails-5'
  gem 'simplecov', require: false
  gem 'wisper-rspec', require: false
end

group :development do
  gem 'letter_opener'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
