# frozen_string_literal: true

require 'spec_helper'

context 'With an API key and live internet connection' do
  include_context "online"

  describe RandomOrg::Basic do
    describe '#usage' do
      it 'can return account usage data' do
        usage = RandomOrg::Basic.usage
        expect(usage).to be_a RandomOrg::Response::Usage
        expect(usage.bits_left).to be_a Integer
        expect(usage.requests_left).to be_a Integer
        expect(usage.total_requests).to be_a Integer
        expect(usage.creation_time).to be_a DateTime
        expect(usage.total_bits).to be_a Integer
        expect(usage.status).to be_a String
      end
    end


    describe '#generate_integers' do
      it 'can return random integers in the given range' do
        min = 0
        max = 100
        n = 5
        integers_response = RandomOrg::Basic.generate_integers(n: n, min: min,
                                                               max: max)
        expect(integers_response).to be_a RandomOrg::Response::Integers
        expect(integers_response.data).to be_a Array
        expect(integers_response.data.size).to be n
        integers_response.data.each do |integer|
          expect(integer).to be <= max
          expect(integer).to be >= min
        end
      end
    end

    describe '#generate_integer_sequences' do
      it 'can generate sequences of random integers' do
        n = 5
        min = 0
        max = 100
        length = 5
        integer_sequences = RandomOrg::Basic.generate_integer_sequences(n: n,
                                                                        min: min,
                                                                        max: max,
                                                                        length: length)
        expect(integer_sequences).to be_a RandomOrg::Response::IntegerSequences
      end
    end

    describe '#generate_decimal_fractions' do
      it 'can return random decimal fractions' do
        n = 1
        decimals = 4
        fractions = RandomOrg::Basic.generate_decimal_fractions(n: n,
                                                                decimal_places: decimals)
        expect(fractions).to be_a RandomOrg::Response::DecimalFractions
      end
    end

    describe '#generate_gaussians' do
      it 'can return random numbers from a gaussian distribution' do
        n = 1
        mean = 0
        standard_deviation = 1
        significant_digits = 2
        gaussian = RandomOrg::Basic.generate_gaussians(n: n, mean: mean,
                                                       standard_deviation: standard_deviation,
                                                       significant_digits: significant_digits)
        expect(gaussian).to be_a RandomOrg::Response::Gaussians
      end
    end
  end
end
