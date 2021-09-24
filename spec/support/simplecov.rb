require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  # minimum_coverage 90

  add_group 'Policies', 'app/policies'
  add_group 'Services', 'app/services'

  add_filter '/channels/'

  # add_filter do |source_file|
  #   source_file.lines.count < 5
  # end
end
