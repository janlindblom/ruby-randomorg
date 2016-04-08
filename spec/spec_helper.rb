require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dotenv'
Dotenv.load

require 'random_org'

RandomOrg.configure do |config|
  config.api_key = ENV['RANDOM_ORG_API_KEY']
end
