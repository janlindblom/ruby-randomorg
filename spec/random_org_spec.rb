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

context 'With an API key and live internet connection' do
  before(:context) do
    expect(ENV['RANDOM_ORG_API_KEY']).to_not be_nil
    expect(ENV['RANDOM_ORG_API_KEY']).to be_a String
    expect(ENV['RANDOM_ORG_API_KEY']).to_not be_empty
    expect(RandomOrg.configuration.api_key).to eq ENV['RANDOM_ORG_API_KEY']
  end

  describe RandomOrg do
    describe '#random_number' do
      it 'can return a random float in the interval 0.0 <= n < 1.0' do
        rndnum = RandomOrg.random_number
        expect(rndnum).to be_a Float
        expect(rndnum).to be < 1.0
        expect(rndnum).to be >= 0.0
      end

      it 'can return a random integer in a given interval 0 <= n < max' do
        max = Random.rand(1..9)
        rndnum = RandomOrg.random_number(max)

        expect(rndnum).to be_a Integer
        expect(rndnum).to be < max
        expect(rndnum).to be >= 0
      end
    end

    describe '#random_bytes' do
      it 'returns a string with 16 random bytes if no arguments are passed' do
        rndstr = RandomOrg.random_bytes

        expect(rndstr).to be_a String
        expect(rndstr.size).to eq(16)
      end

      it 'returns a string with a given number random bytes if a numerical argument is passed' do
        size = Random.rand(24)
        rndstr = RandomOrg.random_bytes(size)

        expect(rndstr).to be_a String
        expect(rndstr.size).to eq(size)
      end
    end

    describe '#uuid' do
      it 'returns a random, proper v4 UUID' do
        rnduuid = RandomOrg.uuid
        expect(rnduuid).to be_a String
        expect(rnduuid).to match(/([a-f\d]{8}(-[a-f\d]{4}){3}-[a-f\d]{12}?)/)
      end
    end

    describe '#base64' do
      it 'returns a base64 encoded string with 16 random bytes if no arguments are passed' do
        rndbstr = RandomOrg.base64

        expect(rndbstr).to be_a String
        expect(rndbstr).to match(/^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)$/)
        expect(rndbstr.unpack('m*')[0].size).to eq(16)
      end

      it 'returns a base64 encoded string with a given number of random bytes if a numerical argument is passed' do
        size = Random.rand(24)
        rndbstr = RandomOrg.base64(size)

        expect(rndbstr).to be_a String
        expect(rndbstr).to match(/^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)$/)
        expect(rndbstr.unpack('m*')[0].size).to eq(size)
      end
    end
  end

  describe RandomOrg::Rng do
    describe '#rand' do
      before(:all) do
        @rng = RandomOrg::Rng.new
      end

      it 'can return a random float in the interval 0.0 <= n < 1.0' do
        rndnum = @rng.rand

        expect(rndnum).to be_a Float
        expect(rndnum).to be >= 0
        expect(rndnum).to be < 1.0
      end

      it 'can return a random float in a given interval 0.0 <= n < max' do
        max = Random.rand(100.0)
        rndnum = @rng.rand(max)

        expect(rndnum).to be_a Float
        expect(rndnum).to be >= 0
        expect(rndnum).to be < max
      end

      it 'can return a random integer in a given interval 0 <= n < max' do
        max = Random.rand(100)
        rndnum = @rng.rand(max)

        expect(rndnum).to be_a Integer
        expect(rndnum).to be >= 0
        expect(rndnum).to be < max
      end

      it 'can return a random element in a given Range 0..n' do
        range = 0..Random.rand(10)
        rndnum = @rng.rand(range)

        expect(rndnum).to be_a Integer
        expect(range.to_a).to include(rndnum)
      end
    end
  end
end
