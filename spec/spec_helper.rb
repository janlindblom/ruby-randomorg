# frozen_string_literal: true

require 'simplecov'
require 'simplecov_small_badge'

SimpleCov.start do
  formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCovSmallBadge::Formatter
  ])
  minimum_coverage 75
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'dotenv'
Dotenv.load

require 'random_org'

RandomOrg.configure do |config|
  config.api_key = ENV['RANDOM_ORG_API_KEY']
end

shared_context "online" do
  before(:context) do
    expect(ENV['RANDOM_ORG_API_KEY']).to_not be_nil
    expect(ENV['RANDOM_ORG_API_KEY']).to be_a String
    expect(ENV['RANDOM_ORG_API_KEY']).to_not be_empty
    expect(RandomOrg.configuration.api_key).to eq ENV['RANDOM_ORG_API_KEY']
  end
end
