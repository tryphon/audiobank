source :rubygems

gem 'rails', '2.3.8'
gem 'inherited_resources', '= 1.0.6'
gem 'rubyjedi-actionwebservice'
gem 'exception_notification'
gem 'rtaglib'

group :development do
  gem 'capistrano'
  gem 'guard'
  gem 'guard-rspec'
  group :linux do
    gem 'rb-inotify'
    gem 'libnotify'
  end
end

group :test do
  gem 'rspec-rails', '< 2'
  gem 'rcov'
  gem 'remarkable_rails'
  gem 'factory_girl'
end

group :production do
  gem 'SyslogLogger'
  gem 'mysql'
end

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails', '0.3.2'
  gem 'cucumber'
  gem 'pickle'
  gem 'factory_girl'
  gem 'launchy'

  gem 'celerity', :require => nil
end
