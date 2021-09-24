require 'capybara/rails'
require 'capybara/rspec'
require 'support/cuprite'

Capybara.default_max_wait_time = 2
Capybara.default_normalize_ws = true
Capybara.save_path = ENV.fetch('CAPYBARA_ARTIFACTS', './tmp/capybara')
Capybara.default_driver = Capybara.javascript_driver = :cuprite
