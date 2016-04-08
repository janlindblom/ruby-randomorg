require "random_org/version"
require "random_org/configuration"
require "random_org/api_client"
require "random_org/rng"

# This library is an interface to the random.org random number generator API
# which generates true random numbers through data gathered from atmospheric
# noise.
#
# This library is implemented as a drop-in replacement for SecureRandom, giving
# you the same methods with the same parameters and mimicing the behaviour of
# the corresponding method in SecureRandom.
module RandomOrg

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
  # @param [Numeric] n the length of the result string, if not specified, 16 is assumed
  def self.random_bytes(n=nil)
    [hex(n)].pack("H*")
  end

  # RandomOrg.random_number generates a random number.
  #
  # If a positive integer is given as +n+,
  # RandomOrg.random_number returns an integer:
  #   0 <= RandomOrg.random_number(n) < n.
  #
  # If 0 is given or an argument is not given,
  # RandomOrg.random_number returns a float:
  #   0.0 <= RandomOrg.random_number() < 1.0.
  #
  # @param [Numeric] n maximum if the value given is +> 0+
  def self.random_number(n=0)
    min = 0

    if n == 0
      max = 1
      req = RandomOrg::ApiClient.build_request(:generate_decimal_fractions, {n: 1, "decimalPlaces" => 16, replacement: true})
    else
      max = n
      req = RandomOrg::ApiClient.build_request(:generate_integers, {n: 1, min: min, max: max, replacement: true, base: 10})
    end

    response = RandomOrg::ApiClient.perform_request(req)
    response["result"]["random"]["data"].first
  end

  # RandomOrg.hex generates a random hex string.
  #
  # The length of the result string is twice of +n+.
  #
  # @param [Numeric] n the length of the random length, if not specified, 16 is assumed
  def self.hex(n=nil)
    n ||= 16
    size = n * 8
    req = RandomOrg::ApiClient.build_request(:generate_blobs, {n: 1, size: size, format: "hex"})
    response = RandomOrg::ApiClient.perform_request(req)
    response["result"]["random"]["data"].first
  end

  # RandomOrg.base64 generates a random base64 string.
  #
  # The length of the result string is about 4/3 of +n+.
  #
  # @param [Numeric] n the length of the random length, if not specified, 16 is assumed
  def self.base64(n=nil)
    n ||= 16
    size = n * 8
    req = RandomOrg::ApiClient.build_request(:generate_blobs, {n: 1, size: size, format: "base64"})
    response = RandomOrg::ApiClient.perform_request(req)
    response["result"]["random"]["data"].first
  end

  # RandomOrg.urlsafe_base64 generates a random URL-safe base64 string.
  #
  # The length of the result string is about 4/3 of +n+.
  #
  # By default, padding is not generated because "=" may be used as a URL
  # delimiter.
  #
  # @param [Numeric] n the length of the random length, if not specified, 16 is assumed
  # @param [Boolean] padding specifies the padding: if false or nil, padding is not generated, otherwise padding is generated
  def self.urlsafe_base64(n=nil, padding=false)
    s = base64
    s.tr!("+/", "-_")
    s.delete!("=") if !padding
    s
  end

  # RandomOrg.uuid generates a v4 random UUID (Universally Unique IDentifier).
  #
  # The version 4 UUID is purely random (except the version). It doesn’t contain
  # meaningful information such as MAC address, time, etc.
  #
  # See RFC 4122 for details of UUID.
  def self.uuid
    req = RandomOrg::ApiClient.build_request(:generate_uuids, {n: 1})
    response = RandomOrg::ApiClient.perform_request(req)
    response["result"]["random"]["data"].first
  end

  class << self
    attr_accessor :configuration
  end


end
