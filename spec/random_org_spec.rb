# frozen_string_literal: true

require 'spec_helper'

context 'With an API key and live internet connection' do
  include_context "online"

  describe RandomOrg do
    describe '#random_number' do
      it 'can return a random float in the interval 0.0 <= n < 1.0' do
        rndnum = RandomOrg.random_number
        expect(rndnum).to be_a Float
        expect(rndnum).to be < 1.0
        expect(rndnum).to be >= 0.0
      end

      it 'can return a random integer in a given interval 0 <= n < max' do
        max = Random.rand(2..99)
        rndnum = RandomOrg.random_number(max - 1)

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
        size = Random.rand(1..22)
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
        expect(rndbstr).to match(%r{^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$})
        expect(rndbstr.unpack('m*')[0].size).to eq(16)
      end

      it 'returns a base64 encoded string with a given number of random bytes if a numerical argument is passed' do
        size = Random.rand(1..24)
        rndbstr = RandomOrg.base64(size)

        expect(rndbstr).to be_a String
        expect(rndbstr).to match(%r{^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$})
        expect(rndbstr.unpack('m*')[0].size).to eq(size)
      end
    end
  end
end
