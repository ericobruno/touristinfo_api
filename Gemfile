source "https://rubygems.org"

ruby "3.2.2"


gem 'rails', '7.0.8.2'

gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false


gem 'mongoid', '~> 7.3.0'
gem 'bson_ext'

gem 'rspec-rails', group: [:development, :test] 

gem 'httparty'

gem 'json', '~> 2.6'

gem 'dotenv-rails'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
