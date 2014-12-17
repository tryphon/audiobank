source 'https://rubygems.org'

gem 'rails', '~> 3.2.18'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'

gem 'inherited_resources', '~> 1.3'
gem 'mahoro'
gem "taglib-ruby", :require => "taglib"

gem 'will_paginate'
gem 'rails_tokeninput'

gem 'listen', '~> 2.7.9'

gem 'exception_notification'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # to fix "undefined method `include_path'"
  # ... and permission denied on .location.yml
  gem 'therubyracer', '= 0.10.2'
  gem 'libv8', "= 3.3.10.4"

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

group :development do
  gem 'capistrano', '~> 2.15.5'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  group :linux do
    gem 'rb-inotify'
    gem 'libnotify'
  end
end

group :development, :test do
  gem 'sqlite3'
  gem "rspec"
  gem "rspec-rails"
  gem 'remarkable_activerecord'
  gem "brakeman", :require => false
  gem 'simplecov'
  gem 'simplecov-rcov'
end

group :test do
  gem "factory_girl_rails"
  gem 'fakeweb'
  gem 'json_spec'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'pickle'
  gem 'launchy'
end

group :production do
  gem 'SyslogLogger'
  gem 'mysql2'
end
