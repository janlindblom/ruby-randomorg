# frozen_string_literal: true

require 'random_org/api_client'
require 'random_org/argument_error'
require 'random_org/response/usage'

module RandomOrg
  # Methods for accessing the "Basic" API.
  class Basic
    class << self
      # RandomOrg.generate_integers generates random integers within a
      # user-defined range.
      #
      # @param [Hash] params parameters
      def generate_integers(params = nil)
        verify_arguments(params)

        req = RandomOrg::ApiClient.build_request('generateIntegers', params)
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::ApiClient.process_response(response)
      end

      # RandomOrg.generate_integer_sequences generates uniform or multiform
      # sequences of random integers within user-defined ranges.
      #
      # @param [Hash] params parameters
      def generate_integer_sequences(params = nil)
        verify_arguments(params)

        verify_min_max(params, -1_000_000_000, 1_000_000_000)

        req = RandomOrg::ApiClient.build_request('generateIntegerSequences',
                                                 params)
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::ApiClient.process_response(response)
      end

      # RandomOrg.generate_decimal_fractions generates random decimal fractions
      # from a uniform distribution across the [0,1] interval with a
      # user-defined number of decimal places.
      #
      # @param [Hash] params parameters
      def generate_decimal_fractions(params = nil)
        verify_arguments(params)
        verify_n(params, 1, 10_000)
        verify_decimal_places(params, 1, 14)
        req = RandomOrg::ApiClient.build_request('generateDecimalFractions',
                                                 params)
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::ApiClient.process_response(response)
      end

      def generate_gaussians
        # TODO
      end

      def generate_strings
        # TODO
      end

      def generate_uuids
        # TODO
      end

      def generate_blobs
        # TODO
      end

      def get_usage
        req = RandomOrg::ApiClient.build_request('getUsage', {})
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::Response::Usage.new RandomOrg::ApiClient.process_response(response, false)
      end

      private

      def verify_decimal_places(params, min, max)
        message = "Hash must include parameter 'decimalPlaces'."
        error = RandomOrg::ArgumentError, message
        raise error unless params.key? 'decimalPlaces'

        message = "Parameter 'decimalPlaces' must be in the " \
                  "[#{min}, #{max}] range."
        error = RandomOrg::ArgumentError, message
        num = params['decimalPlaces']
        raise error if num < min || num > max
      end

      def verify_n(params, min, max)
        message = "params must include parameter 'n'."
        raise RandomOrg::ArgumentError, message unless params.key? 'n'

        num = params[:n]
        message = "n must be in the [#{min}, #{max}] range."
        error = RandomOrg::ArgumentError, message
        raise error if num < min || num > max
      end

      def verify_range(key, num, min, max)
        message = "#{key} values must be in the [#{min}, #{max}] range."
        error = RandomOrg::ArgumentError, message
        raise error if num < min || num > max
      end

      def verify_arguments(params)
        error = RandomOrg::ArgumentError, 'Missing required arguments.'
        raise error if params.nil?
      end

      def verify_min_max(params, allowed_min, allowed_max)
        %i[min max].each do |k|
          if params[k].is_a? Numeric
            verify_range(k, params[k], allowed_min, allowed_max)
          elsif params[k].is_a? Array
            params[k].each do |num|
              verify_range(k, num, allowed_min, allowed_max)
            end
          end
        end
      end
    end
  end
end
