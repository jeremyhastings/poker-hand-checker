require 'capybara/cuprite'
require 'support/helpers/cuprite'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{
      window_size: [1200, 800],
      browser_options: {},
      process_timeout: 10,
      inspector: true,
      headless: !ENV['HEADLESS'].in?(%w[n 0 no false])
    }
  )
end
