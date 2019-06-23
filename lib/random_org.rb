# frozen_string_literal: true

require 'version'
require 'random_org/argument_error'
require 'random_org/api_error'
require 'random_org/api_server_error'
require 'random_org/wrong_api_key_error'
require 'random_org/configuration'
require 'random_org/api_client'
require 'random_org/basic'
require 'random_org/rng'

# This library is an interface to the random.org random number generator API
# which generates true random numbers through data gathered from atmospheric
# noise.
#
# This library is implemented as a drop-in replacement for SecureRandom, giving
# you the same methods with the same parameters and mimicing the behaviour of
# the corresponding method in SecureRandom.
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
  # If a positive integer is given as +maximum+,
  # RandomOrg.random_number returns an integer:
  #   +0 <= RandomOrg.random_number(maximum) < maximum+.
  #
  # If 0 is given or an argument is not given,
  # RandomOrg.random_number returns a float:
  #   +0.0 <= RandomOrg.random_number() < 1.0+.
  #
  # @param [Numeric] maximum maximum if the value given is +> 0+
  def self.random_number(maximum = 0)
    min = 0
    req = if maximum.zero?
            request_default
          else
            # random.org treats the range as inclusive so set max=max-1
            request_with_min_max(min, maximum - 1)
          end
    response = RandomOrg::ApiClient.perform_request(req)
    RandomOrg::ApiClient.process_response(response)
  end

  # RandomOrg.hex generates a random hex string.
  #
  # The length of the result string is twice of +length+.
  #
  # @param [Numeric] length the length of the random string, if not specified,
  #   16 is assumed.
  def self.hex(length = 16)
    size = length * 8
    req = RandomOrg::ApiClient.build_request('generateBlobs',
                                             n: 1,
                                             size: size,
                                             format: 'hex')
    response = RandomOrg::ApiClient.perform_request(req)
    RandomOrg::ApiClient.process_response(response)
  end

  # RandomOrg.base64 generates a random base64 string.
  #
  # The length of the result string is about 4/3 of +length+.
  #
  # @param [Numeric] length the length of the random string, if not specified,
  #   16 is assumed.
  def self.base64(length = 16)
    size = length * 8
    req = RandomOrg::ApiClient.build_request('generateBlobs',
                                             n: 1,
                                             size: size,
                                             format: 'base64')
    response = RandomOrg::ApiClient.perform_request(req)
    RandomOrg::ApiClient.process_response(response)
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
  def self.urlsafe_base64(length = nil, padding = false)
    s = base64 length
    s.tr!('+/', '-_')
    s.delete!('=') unless padding
    s
  end

  # RandomOrg.uuid generates a v4 random UUID (Universally Unique IDentifier).
  #
  # The version 4 UUID is purely random (except the version). It doesn't
  #   contain meaningful information such as MAC address, time, etc.
  #
  # See RFC 4122 for details of UUID.
  def self.uuid
    req = RandomOrg::ApiClient.build_request('generateUUIDs', n: 1)
    response = RandomOrg::ApiClient.perform_request(req)
    response['result']['random']['data'].first
  end

  class << self
    attr_accessor :configuration

    private

    def request_with_min_max(min, max)
      RandomOrg::ApiClient.build_request('generateIntegers',
                                         n: 1,
                                         min: min,
                                         max: max,
                                         replacement: true,
                                         base: 10)
    end

    def request_default
      RandomOrg::ApiClient.build_request('generateDecimalFractions',
                                         n: 1,
                                         'decimalPlaces' => 14,
                                         replacement: true)
    end

    def process_response(response)
      bad_response_error(response) unless response.key? 'result'
      result = response['result']
      bad_response_error(response) unless result.key? 'random'
      random = result['random']
      bad_response_error(response) unless random.key? 'data'
      random['data'].first
    end

    def bad_response_error(response)
      raise ApiError, "Something is wrong with the response: #{response}"
    end
  end
end
