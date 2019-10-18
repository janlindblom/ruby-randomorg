# frozen_string_literal: true

require 'random_org/api_client'
require 'random_org/argument_error'
require 'random_org/response/usage'

module RandomOrg
  # Methods for accessing the "Basic" API.
  class Basic
    class << self
      # Generates random integers within a user-defined range.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateIntegers
      # @param [Hash] opts parameters
      # @option opts [Integer] :n how many random integers you need. Must be
      #   within the [1,1e4] range.
      # @option opts [Integer] :min the lower boundary for the range from which
      #   the random numbers will be picked. Must be within the +[-1e9,1e9]+
      #   range.
      # @option opts [Integer] :max the upper boundary for the range from which
      #   the random numbers will be picked. Must be within the +[-1e9,1e9]+
      #   range.
      # @option opts [Boolean] :replacement (true) specifies whether the random
      #   numbers should be picked with replacement. The default will cause the
      #   numbers to be picked with replacement, i.e., the resulting numbers
      #   may contain duplicate values (like a series of dice rolls). If you
      #   want the numbers picked to be unique (like raffle tickets drawn from
      #   a container), set this value to +false+.
      # @option opts [Integer] :base (10) specifies the base that will be used
      #   to display the numbers. Values allowed are +2+, +8+, +10+ and +16+.
      # @return [RandomOrg::Response::Integers] an Integers response object.
      def generate_integers(opts = nil)
        verify_arguments(opts, %i[n min max])

        req = RandomOrg::ApiClient.build_request('generateIntegers', opts)
        response = RandomOrg::ApiClient.perform_request(req)
        processed = RandomOrg::ApiClient.process_response(response)
        RandomOrg::Response::Integers.new processed
      end

      # Generates uniform or multiform sequences of random integers within
      # user-defined ranges.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateIntegerSequences
      # @param [Hash] opts parameters
      # @option opts [Integer] :n how many random integers you need. Must be
      #   within the [1,1e4] range.
      # @option opts [Integer] :min the lower boundary for the range from which
      #   the random numbers will be picked. Must be within the +[-1e9,1e9]+
      #   range.
      # @option opts [Integer] :max the upper boundary for the range from which
      #   the random numbers will be picked. Must be within the +[-1e9,1e9]+
      #   range.
      # @option opts [Integer] :length This parameter specifies the lengths of
      #   the sequences requested. For uniform sequences, length must be an
      #   integer in the +[1,10000]+ range.
      # @option opts [Boolean] :replacement (true) specifies whether the random
      #   numbers should be picked with replacement. The default will cause the
      #   numbers to be picked with replacement, i.e., the resulting numbers
      #   may contain duplicate values (like a series of dice rolls). If you
      #   want the numbers picked to be unique (like raffle tickets drawn from
      #   a container), set this value to +false+.
      # @option opts [Integer] :base (10) specifies the base that will be used
      #   to display the numbers. Values allowed are +2+, +8+, +10+ and +16+.
      # @return [RandomOrg::Response::IntegerSequences]
      def generate_integer_sequences(opts = nil)
        verify_arguments(opts, %i[n length min max])

        verify_min_max(opts, -1_000_000_000, 1_000_000_000)

        req = RandomOrg::ApiClient.build_request('generateIntegerSequences',
                                                 opts)
        response = RandomOrg::ApiClient.perform_request(req)
        processed = RandomOrg::ApiClient.process_response(response)
        RandomOrg::Response::IntegerSequences.new processed
      end

      # Generates random decimal fractions from a uniform distribution across
      # the [0,1] interval with a user-defined number of decimal places.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateDecimalFractions
      # @param [Hash] opts parameters
      # @option opts [Integer] :n how many random decimal fractions you need.
      #   Must be within the +[1,10000]+ range.
      # @option opts [Integer] :decimal_places the number of decimal places to
      #   use. Must be within the +[1,14]+ range.
      # @option opts [Boolean] :replacement (true) specifies whether the random
      #   numbers should be picked with replacement. The default will cause the
      #   numbers to be picked with replacement, i.e., the resulting numbers
      #   may contain duplicate values (like a series of dice rolls). If you
      #   want the numbers picked to be unique (like raffle tickets drawn from
      #   a container), set this value to +false+.
      # @return [RandomOrg::Response::DecimalFractions]
      def generate_decimal_fractions(opts = nil)
        verify_arguments(opts, %i[n decimal_places])
        opts = { n: opts[:n], 'decimalPlaces' => opts[:decimal_places] }
        verify_n(opts, 1, 10_000)
        verify_decimal_places(opts, 1, 14)
        req = RandomOrg::ApiClient.build_request('generateDecimalFractions',
                                                 opts)
        response = RandomOrg::ApiClient.perform_request(req)
        processed = RandomOrg::ApiClient.process_response(response)
        RandomOrg::Response::DecimalFractions.new processed
      end

      # Generates true random numbers from a Gaussian distribution (also
      # known as a normal distribution).
      #
      # @see https://api.random.org/json-rpc/2/basic#generateGaussians
      # @param [Hash] opts parameters
      # @option opts [Integer] :n how many random decimal fractions you need.
      #   Must be within the +[1,10000]+ range.
      # @option opts [Integer] :mean the distribution's mean. Must be within
      #   the +[-1000000,1000000]+ range.
      # @option opts [Integer] :standard_deviation the distribution's standard
      #   deviation. Must be within the +[-1000000,1000000]+ range.
      # @option opts [Integer] :significant_digits the number of significant
      #   digits to use. Must be within the +[2,14]+ range.
      # @return [RandomOrg::Response::Gaussians]
      def generate_gaussians(opts = nil)
        verify_arguments(opts, %i[n mean standard_deviation significant_digits])
        opts = { n: opts[:n], 'standardDeviation' => opts[:standard_deviation],
                 'significantDigits' => opts[:significant_digits] }
        verify_n(opts, 1, 10_000)
      end

      # TODO
      def generate_strings
        # TODO
      end

      # TODO
      def generate_uuids
        # TODO
      end

      # TODO
      def generate_blobs
        # TODO
      end

      # Returns information related to the the usage of a given API key.
      #
      # @return [RandomOrg::Response::Usage]
      def usage
        req = RandomOrg::ApiClient.build_request('getUsage', {})
        response = RandomOrg::ApiClient.perform_request(req)
        processed = RandomOrg::ApiClient.process_response(response, false)
        RandomOrg::Response::Usage.new processed
      end

      private

      def verify_decimal_places(params, min, max)
        message = "Parameter 'decimalPlaces' must be in the " \
                  "[#{min}, #{max}] range."
        num = params['decimalPlaces']
        raise RandomOrg::ArgumentError, message if num < min || num > max
      end

      def verify_n(params, min, max)
        unless params.key?('n') || params.key?(:n)
          message = "params must include parameter 'n'."
          raise RandomOrg::ArgumentError, message
        end

        num = params[:n]
        message = "n must be in the [#{min}, #{max}] range."
        raise RandomOrg::ArgumentError, message if num < min || num > max
      end

      def verify_param(param, params = {}, min = nil, max = nil)
        message = 'invalid min or max value'
        raise RandomOrg::ArgumentError, message if [min, max].any?(nil)

        message = "parameters must include parameter '#{param}'."
        unless params.key?(param) || params.key?(param.to_sym)
          raise RandomOrg::ArgumentError, message
        end

        num = params[param]
        message = "parameter must be in the [#{min}, #{max}] range."
        raise RandomOrg::ArgumentError, message if num < min || num > max
      end

      def verify_range(key, num, min, max)
        message = "#{key} values must be in the [#{min}, #{max}] range."
        raise RandomOrg::ArgumentError, message if num < min || num > max
      end

      def verify_arguments(params, required_keys = [])
        if params.nil?
          raise RandomOrg::ArgumentError, 'Missing required arguments.'
        end

        required_keys.each do |key|
          unless params.key? key
            raise RandomOrg::ArgumentError, 'Missing required parameters.'
          end
        end
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
