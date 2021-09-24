# module Helpers
#   module Warden
#     include ::Warden::Test::Helpers
#
#     def self.included(base)
#       base.before { ::Warden.test_mode! }
#       base.after { ::Warden.test_reset! }
#       super
#     end
#
#     def sign_in(resource)
#       login_as(resource, scope: warden_scope(resource))
#     end
#
#     def sign_out(resource)
#       logout(warden_scope(resource))
#     end
#
#     # :reek:UtilityFunction
#     def inject_session(hash)
#       ::Warden.on_next_request do |proxy|
#         hash.each do |key, value|
#           proxy.raw_session[key] = value
#         end
#       end
#     end
#
#     private
#
#     # :reek:UtilityFunction
#     def warden_scope(resource)
#       resource.class.name.underscore.to_sym
#     end
#   end
# end
#
# RSpec.configure do |config|
#   config.include Helpers::Warden, type: :request
#   config.include Helpers::Warden, type: :system
# end
