module Helpers
  module Cuprite
    # Drop #pause anywhere in a test to stop the execution.
    # Useful when you want to checkout the contents of a web page in the middle of a test running in a headful mode.
    def pause
      page.driver.pause
    end

    # Drop #debug anywhere in a test to open a Chrome inspector and pause the execution.
    def debug(*args)
      page.driver.debug(*args)
    end
  end
end

RSpec.configure do |config|
  config.include Helpers::Cuprite, type: :system
end
