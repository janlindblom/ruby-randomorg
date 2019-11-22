# frozen_string_literal: true

require 'random_org/api_client'

module RandomOrg
  # Use random.org as a Random Number Generator (RNG). Suitable for use in
  # things like:
  #
  #   [1,3,5,78,9,5,3].sample(random: RandomOrg::Rng.new)
  #   # => 5
  class Rng
    # Returns a random binary string containing +size+ bytes.
    # @return [String] a random binary string containing +size+ bytes
    def bytes(size = nil)
      RandomOrg::Rng.random_bytes(size)
    end

    # Returns a random binary string containing +size+ bytes.
    # @return [String] a random binary string containing +size+ bytes
    def self.bytes(size = nil)
      RandomOrg.random_bytes(size)
    end

    # When +max+ is an Integer, +rand+ returns a random integer greater than or
    # equal to zero and less than +max+.
    #
    # When +max+ is a Float, +rand+ returns a random floating point number
    # between +0.0+ and +max+, including +0.0+ and excluding +max+.
    #
    # When +max+ is a Range, +rand+ returns a random number where
    # +range.member?(number) == true+.
    #
    # @param [Integer, Float, Range] max maximum
    # @return [Numeric] a random number in the interval +0 <= n < max+
    def rand(max = nil)
      RandomOrg::Rng.rand(max)
    end

    # When +max+ is an Integer, +rand+ returns a random integer greater than or
    # equal to zero and less than +max+.
    #
    # When +max+ is a Float, +rand+ returns a random floating point number
    # between +0.0+ and +max+, including +0.0+ and excluding +max+.
    #
    # When +max+ is a Range, +rand+ returns a random number where
    # +range.member?(number) == true+.
    #
    # @param [nil, Integer, Float, Range] max maximum
    # @return [Numeric] a random number in the interval +0 <= n < max+
    def self.rand(max = nil)
      if max.is_a? Range
        max_array = max.to_a
        return max_array.sample(random: RandomOrg::Rng.new)
      end
      return RandomOrg.random_number if max.nil? || max.zero?
      return RandomOrg.random_number(max) if max.is_a? Numeric

      raise ArgumentError, 'Given argument must be correct type.'
    end
  end
end
