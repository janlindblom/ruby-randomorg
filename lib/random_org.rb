# frozen_string_literal: true

require 'version'
require 'random_org/argument_error'
require 'random_org/api_error'
require 'random_org/api_server_error'
require 'random_org/wrong_api_key_error'
require 'random_org/configuration'
require 'random_org/api_client'
require 'random_org/response'
require 'random_org/basic'
require 'random_org/rng'

# This library is an interface to the random.org random number generator API
# which generates true random numbers through data gathered from atmospheric
# noise.
#
# This library can be used as a drop-in replacement for SecureRandom, giving
# you the same methods with the same parameters and mimicing the behaviour of
# the corresponding method in SecureRandom.
#
# @author Jan Lindblom <janlindblom@fastmail.fm>
module RandomOrg
  is_versioned
  # Modify the current configuration.
  #
  # @example
  #   RandomOrg.configure do |config|
  #     config.api_key = "YOUR_API_KEY"
  #   end
  #
  # @yieldparam [RandomOrg::Configuration] config current configuration
  def self.configure
    self.configuration ||= RandomOrg::Configuration.new
    yield self.configuration
  end

  # RandomOrg.random_bytes generates a random binary string.
  #
  # @param [Numeric] length the length of the result string, if not specified,
  #   16 is assumed.
  def self.random_bytes(length = 16)
    [hex(length)].pack('H*')
  end

  # RandomOrg.random_number generates a random number.
  #
  # If a positive integer is given as +maximum+, it returns an Integer.
  # If +0+ is given or an argument is not given, it returns a Float.
  #
  # @example Generating random integer with a given maximum
  #   0 <= RandomOrg.random_number(42) && RandomOrg.random_number(42) <= 42
  #   => true
  #
  # @example Generating random Float
  #   0 <= RandomOrg.random_number && RandomOrg.random_number <= 1.0
  #   => true
  #
  # @param [Integer, Float] maximum maximum if the value given is +> 0+
  # @return [Integer, Float] a random number in the range +[0,1.0]+ or
  #   +[0,maximum]+.
  def self.random_number(maximum = 0)
    if maximum.is_a?(Float) || maximum.nil? || maximum.zero?
      response = RandomOrg::Basic.generate_decimal_fractions(n: 1, min: 0,
                                                             decimal_places: 14)
      return response.data.first * maximum if maximum.is_a? Float
    elsif maximum.is_a? Integer
      response = RandomOrg::Basic.generate_integers(n: 1, min: 0,
                                                    max: maximum)
    end
    response.data.first
  end

  # RandomOrg.hex generates a random hex string.
  #
  # The length of the result string is twice of +length+.
  #
  # @param [Integer] length the length of the random string, if not specified,
  #   16 is assumed.
  # @return [String] a random hex string.
  def self.hex(length = 16)
    size = length * 8
    response = RandomOrg::Basic.generate_blobs(n: 1, size: size, format: :hex)
    response.data.first
  end

  # RandomOrg.base64 generates a random base64 string.
  #
  # The length of the result string is about 4/3 of +length+.
  #
  # @param [Integer] length the length of the random string, if not specified,
  #   16 is assumed.
  # @return [String] a random base64 string.
  def self.base64(length = 16)
    size = length * 8
    response = RandomOrg::Basic.generate_blobs(n: 1, size: size)
    response.data.first
  end

  # RandomOrg.urlsafe_base64 generates a random URL-safe base64 string.
  #
  # The length of the result string is about 4/3 of +n+.
  #
  # By default, padding is not generated because "=" may be used as a URL
  # delimiter.
  #
  # @param [Numeric] length the length of the random length, if not specified,
  #   16 is assumed.
  # @param [Boolean] padding specifies the padding: if false or nil, padding is
  #   not generated, otherwise padding is generated.
  # @return [String] a random URL-safe base64 string.
  def self.urlsafe_base64(length = 16, padding: false)
    s = base64(length)
    s.tr!('+/', '-_')
    s.delete!('=') unless padding
    s
  end

  # RandomOrg.uuid generates a v4 random UUID (Universally Unique IDentifier).
  #
  # The version 4 UUID is purely random (except the version). It doesn't
  # contain meaningful information such as MAC address, time, etc.
  #
  # See RFC 4122 for details of UUID.
  # @return [String] a v4 random UUID (Universally Unique IDentifier).
  def self.uuid
    RandomOrg::Basic.generate_uuids(n: 1).data.first
  end

  class << self
    attr_accessor :configuration

    private

    def request_with_min_max(min, max)
      RandomOrg::Basic.generate_integers(n: 1, min: min, max: max,
                                         replacement: true, base: 10)
    end

    def request_default
      RandomOrg::Basic.generate_decimal_fractions(n: 1, decimal_places: 14,
                                                  replacement: true)
    end
  end
end
