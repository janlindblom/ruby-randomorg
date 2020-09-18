# frozen_string_literal: true

require 'random_org/api_client'
require 'random_org/argument_error'
require 'random_org/response'

module RandomOrg
  # Methods for accessing the "Basic" API.
  class Basic
    class << self
      # Generates random integers within a user-defined range.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateIntegers
      # @param [Hash] opts options
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
        RandomOrg::Response::Integers.new perform_and_process(
          'generateIntegers',
          opts
        )
      end

      # Generates uniform or multiform sequences of random integers within
      # user-defined ranges.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateIntegerSequences
      # @param [Hash] opts options
      # @option opts [Integer] :n how many random integers you need. Must be
      #   within the [1,1e4] range.
      # @option opts [Integer, Array] :min the lower boundary for the range
      #   from which the random numbers will be picked. Must be within the
      #   +[-1e9,1e9]+ range. For multiform sequences, +:min+ can be an array
      #   with +n+ integers, each specifying the lower boundary of the sequence
      #   identified by its index.
      # @option opts [Integer, Array] :max the upper boundary for the range
      #   from which the random numbers will be picked. Must be within the
      #   +[-1e9,1e9]+ range. For multiform sequences, +:max+ can be an array
      #   with +n+ integers, each specifying the lower boundary of the sequence
      #   identified by its index.
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
        verify_n(opts, 1, 10_000)
        verify_param(:length, opts, 1, 10_000)
        verify_min_max(opts, -1_000_000_000, 1_000_000_000)
        RandomOrg::Response::IntegerSequences.new perform_and_process(
          'generateIntegerSequences',
          opts
        )
      end

      # Generates random decimal fractions from a uniform distribution across
      # the [0,1] interval with a user-defined number of decimal places.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateDecimalFractions
      # @param [Hash] opts options
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
        verify_n(opts, 1, 10_000)
        verify_param(:decimal_places, opts, 1, 14)
        opts = { n: opts[:n], 'decimalPlaces' => opts[:decimal_places] }
        RandomOrg::Response::DecimalFractions.new perform_and_process(
          'generateDecimalFractions',
          opts
        )
      end

      # Generates true random numbers from a Gaussian distribution (also
      # known as a normal distribution).
      #
      # @see https://api.random.org/json-rpc/2/basic#generateGaussians
      #
      # @param [Hash] opts options
      # @option opts [Integer] :n how many random numbers you need. Must be
      #   within the +[1,10000]+ range.
      # @option opts [Integer] :mean the distribution's mean. Must be within
      #   the +[-1000000,1000000]+ range.
      # @option opts [Integer] :standard_deviation the distribution's standard
      #   deviation. Must be within the +[-1000000,1000000]+ range.
      # @option opts [Integer] :significant_digits the number of significant
      #   digits to use. Must be within the +[2,14]+ range.
      # @return [RandomOrg::Response::Gaussians]
      def generate_gaussians(opts = nil)
        verify_arguments(opts, %i[n mean standard_deviation significant_digits])
        verify_n(opts, 1, 10_000)
        verify_param(:mean, opts, -1_000_000, 1_000_000)
        verify_param(:standard_deviation, opts, -1_000_000, 1_000_000)
        verify_param(:significant_digits, opts, 2, 14)
        opts = { n: opts[:n], mean: opts[:mean],
                 'standardDeviation' => opts[:standard_deviation],
                 'significantDigits' => opts[:significant_digits] }
        RandomOrg::Response::Gaussians.new perform_and_process(
          'generateGaussians',
          opts
        )
      end

      # Generates true random strings.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateStrings
      #
      # @param [Hash] opts options
      # @option opts [Integer] :n how many random decimal fractions you need.
      #   Must be within the +[1,10000]+ range.
      # @option opts [Integer] :length the length of each string. Must be
      #   within the +[1,32]+ range. All strings will be of the same length.
      # @option opts [Integer] :characters a string that contains the set of
      #   characters that are allowed to occur in the random strings. The
      #   maximum number of characters is +128+.
      # @return [RandomOrg::Response::Strings]
      def generate_strings(opts = nil)
        verify_arguments(opts, %i[n length characters])
        verify_n(opts, 1, 10_000)
        verify_param(:length, opts, 1, 32)
        verify_string(:characters, opts, 0, 128)
        RandomOrg::Response::Strings.new perform_and_process(
          'generateStrings',
          opts
        )
      end

      #
      # Generates version 4 true random Universally Unique IDentifiers (UUIDs)
      # in accordance with section 4.4 of RFC 4122.
      #
      # @see https://api.random.org/json-rpc/2/basic#generateUUIDs
      # @see http://www.ietf.org/rfc/rfc4122.txt RFC 4122
      #
      # @param [Hash] opts options
      # @option opts [Integer] :n how many random UUIDs you need. Must be
      #   within the +[1,1000]+ range.
      # @return [RandomOrg::Response::Strings]
      def generate_uuids(opts = nil)
        verify_arguments(opts, %i[n])
        verify_n(opts, 1, 1_000)
        RandomOrg::Response::UUIDs.new perform_and_process(
          'generateUUIDs',
          opts
        )
      end

      # Generates Binary Large OBjects (BLOBs) containing true random data.
      #
      # The total size of all blobs requested must not exceed +1,048,576+ bits
      # (+128 KiB+).
      #
      # @param [Hash] opts options
      # @option opts [Integer] :n how many random blobs you need. Must be
      #   within the +[1,100]+ range.
      # @option opts [Integer] :size the size of each blob, measured in bits.
      #   Must be within the +[1,1048576]+ range and must be divisible by +8+.
      # @option opts [Symbol] :format (:base64) specifies the format in which
      #   the blobs will be returned. Values allowed are +base64+ and +hex+.
      def generate_blobs(opts = nil)
        verify_arguments(opts, %i[n size])
        verify_n(opts, 1, 100)
        verify_param(:size, opts, 1, 1_048_576)
        if opts.key? :format
          verify_symbol(opts[:format], %i[base64 hex])
        end
        if opts[:size] % 8 != 0
          raise RandomOrg::ArgumentError, 'size parameter is not divisable by 8'
        end

        RandomOrg::Response::Blobs.new perform_and_process(
          'generateBlobs',
          opts
        )
      end

      # Returns information related to the the usage of a given API key.
      #
      # @return [RandomOrg::Response::Usage]
      def usage
        RandomOrg::Response::Usage.new perform_and_process('getUsage', {},
                                                           false)
      end

      private

      def verify_symbol(symbol, allowed = [])
        message = "symbol #{symbol} is not allowed"
        raise RandomOrg::ArgumentError, message unless allowed.member? symbol
      end

      def perform_and_process(function = nil, opts = nil, random_data = true)
        req = RandomOrg::ApiClient.build_request(function, opts)
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::ApiClient.process_response(response, random_data)
      end

      def verify_decimal_places(params, min, max)
        verify_param('decimalPlaces', params, min, max)
      end

      def verify_n(params, min, max)
        verify_param(:n, params, min, max)
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

      def verify_string(param, params, min_length = 0, max_length = 0)
        content = params[param]
        if min_length.positive?
          message = "string is too short (#{content.length} < #{min_length})"
          raise RandomOrg::ArgumentError, message if content.length < min_length
        elsif max_length.positive?
          message = "string is too long (#{content.length} > #{max_length})"
          raise RandomOrg::ArgumentError, message if content.length > max_length
        end
      end

      def verify_range(key, num, min, max)
        message = "#{key} values must be in the [#{min}, #{max}] range."
        raise RandomOrg::ArgumentError, message if num < min || num > max
      end

      def verify_arguments(opts, required_keys = [])
        if opts.nil?
          raise RandomOrg::ArgumentError, 'Missing required arguments.'
        end

        required_keys.each do |key|
          unless opts.key? key
            raise RandomOrg::ArgumentError, "Missing required parameter #{key}"
          end
        end
      end

      def verify_min_max(params, allowed_min, allowed_max)
        %i[min max].each do |k|
          case params[k]
          when Numeric
            verify_range(k, params[k], allowed_min, allowed_max)
          when Array
            params[k].each do |num|
              verify_range(k, num, allowed_min, allowed_max)
            end
          end
        end
      end
    end
  end
end
