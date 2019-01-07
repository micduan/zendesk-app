ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/test_unit'
include WebMock

class ActiveSupport::TestCase
	WebMock.disable_net_connect!
  	# Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  	fixtures :all

  	# Add more helper methods to be used by all tests here...
end
