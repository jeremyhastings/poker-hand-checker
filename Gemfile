source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').chomp

### Default Ruby on Rails Installation Files
gem 'bootsnap', '>= 1.4.2', require: false # Reduces boot times through caching; required in config/boot.rb
gem 'jbuilder', '~> 2.7' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder\
gem 'puma', '~> 5.0' # Use Puma as the app server
gem 'rails', '~> 6.1.0', '>= 6.1.3' # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'turbolinks', '~> 5' # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 5.0' # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

# gem 'redis', '~> 4.0' # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7' # Use Active Model has_secure_password

# gem 'image_processing', '~> 1.2' # Use Active Storage variant

group :development, :test do
  ### Default Ruby on Rails Installation files for Development Environment
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Call 'byebug' anywhere to stop execution and get a console

  ### Installed for Project
  gem 'factory_bot_rails' # https://github.com/thoughtbot/factory_bot_rails
  gem 'faker' # https://github.com/faker-ruby/faker
  gem 'reek', require: false # https://github.com/troessner/reek (Linter)
  gem 'rspec-rails', '~> 5.0.0' # https://github.com/rspec/rspec-rails (Rspec Tests)
  gem 'rubocop', '~> 1.0', require: false # https://github.com/rubocop-hq/rubocop (Linter)
  gem 'rubocop-performance', require: false # https://github.com/rubocop/rubocop-performance
  gem 'rubocop-rails', require: false # https://github.com/rubocop-hq/rubocop-rails (Linter)
  gem 'rubocop-rspec', require: false # https://github.com/rubocop-hq/rubocop-rspec (Linter)
  gem 'sqlite3'
end

group :development do
  ### Default Ruby on Rails Installation files for Development Environment
  gem 'listen', '~> 3.2' # Access an interactive console on exception pages or by calling 'console' anywhere.
  gem 'spring' # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  ### Installed for Project
  gem 'pg'
end

group :test do
  ### Installed for Project
  gem 'capybara'
  gem 'cuprite' # https://github.com/rubycdp/cuprite
  gem 'rspec_junit_formatter' # Needed for CircleCI.
  # TODO: This should be able to be removed once Rails 6.1 is released. https://github.com/rails/rails/pull/39179
  # gem 'selenium-webdriver'
  gem 'simplecov', require: false # https://github.com/simplecov-ruby/simplecov
  gem 'timecop'
  gem 'vcr', require: false
  gem 'webmock', require: false
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files
