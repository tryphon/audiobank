source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'json'

gem 'inherited_resources', '~> 1.3'
gem 'rtaglib'
gem 'mahoro'
gem 'will_paginate'

gem 'exception_notification'
gem 'dynamic_form'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

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
  gem 'capistrano'
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
  gem "rspec"
  gem "rspec-rails"
  gem 'remarkable_activerecord'
end

group :test do
  gem "factory_girl_rails"
  gem 'fakeweb'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'pickle'
  gem 'launchy'
end

group :production do
  gem 'SyslogLogger'
  gem 'mysql'
end
