# frozen_string_literal: true

require 'spec_helper'

describe RandomOrg do
  it 'has a version number' do
    expect(RandomOrg::VERSION).not_to be nil
  end
end

describe RandomOrg::Configuration do
  it 'accepts an API key in the configuration object' do
    expect(RandomOrg.configuration.respond_to?(:api_key)).to be true
  end
end

describe RandomOrg::Rng do
  it 'responds to #rand' do
    expect(RandomOrg::Rng.new.respond_to?(:rand)).to be true
  end
end
