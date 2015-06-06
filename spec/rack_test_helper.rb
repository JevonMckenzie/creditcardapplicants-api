ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require 'dotenv'
Dotenv.load

require_relative '../app'

include Rack::Test::Methods

def app
  CreditCardAPI
end
