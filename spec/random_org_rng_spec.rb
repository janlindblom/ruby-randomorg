# frozen_string_literal: true

require 'spec_helper'

context 'With an API key and live internet connection' do
  include_context "online"

  describe RandomOrg::Rng do
    describe '#rand' do
      before(:all) do
        @rng = RandomOrg::Rng.new
      end

      it 'can return a random float in the interval 0.0 <= n < 1.0' do
        (1..3).each do |_i|
          rndnum = @rng.rand

          expect(rndnum).to be_a Float
          expect(rndnum).to be >= 0
          expect(rndnum).to be < 1.0
        end
      end

      it 'can return a random float in a given interval 0.0 <= n < max' do
        (1..3).each do |_i|
          max = Random.rand(100.0)
          rndnum = @rng.rand(max)

          expect(rndnum).to be_a Float
          expect(rndnum).to be >= 0
          expect(rndnum).to be < max
        end
      end

      it 'can return a random integer in a given interval 0 <= n < max' do
        (1..3).each do |_i|
          max = Random.rand(1..100)
          rndnum = @rng.rand(max)

          expect(rndnum).to be_a Integer
          expect(rndnum).to be >= 0
          expect(rndnum).to be < max
        end
      end

      it 'can return a random element in a given Range 0..n' do
        range = 0..(Random.rand(1..10))
        rndnum = @rng.rand(range)

        expect(rndnum).to be_a Integer
        expect(range.to_a).to include(rndnum)
      end

      it 'can return a String of random bytes' do
        rnd_str = @rng.bytes 8
        expect(rnd_str).to be_a String
        expect(rnd_str.length).to be 8
      end

      it 'throws an error if arguments are of the wrong type' do
        expect{@rng.rand("String")}.to raise_error(RandomOrg::ArgumentError)
      end
    end
  end
end
