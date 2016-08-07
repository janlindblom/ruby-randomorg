require "random_org/api_client"

module RandomOrg
  # Use random.org as a Random Number Generator (RNG). Suitable for use in
  # things like:
  #
  #   [1,3,5,78,9,5,3].sample(random: RandomOrg::Rng.new)
  #   # => 5
  class Rng

    # Returns a random binary string containing +size+ bytes.
    # @return [String] a random binary string containing +size+ bytes
    def bytes(size=nil)
      RandomOrg::Rng.random_bytes(size)
    end

    # Returns a random binary string containing +size+ bytes.
    # @return [String] a random binary string containing +size+ bytes
    def self.bytes(size=nil)
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
    # @param [Numeric] max maximum
    # @return [Numeric] a random number in the interval +0 <= n < max+
    def rand(max=nil)
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
    # @param [Numeric] max maximum
    # @return [Numeric] a random number in the interval +0 <= n < max+
    def self.rand(max=nil)
      return RandomOrg.random_number if max.nil? or max == 0
      if max.is_a? Integer
        return RandomOrg.random_number(max)
      elsif max.is_a? Float
        whole = max.to_i
        rem = ((max - whole) * (10 ** 9)).round
        whole = RandomOrg.random_number(whole)
        rem = RandomOrg.random_number(rem).to_f / (10 ** 9)
        return whole + rem
      elsif max.is_a? Range
        return max.to_a.sample(random: RandomOrg::Rng.new)
      else
        raise ArgumentError.new("Given argument max must be nil, Integer, Float or Range.")
      end
    end
  end
end
