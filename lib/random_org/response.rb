# frozen_string_literal: true

require 'random_org/response/random_data'
require 'random_org/response/usage'
require 'random_org/response/integers'
require 'random_org/response/integer_sequences'
require 'random_org/response/decimal_fractions'

module RandomOrg
  # An API response as an object.
  #
  # @version 0.2.2
  # @author Jan Lindblom <janlindblom@fastmail.fm>
  module Response
    def self.convert_hash_keys(value)
      return value unless value.is_a?(Hash)

      result = value.each_with_object({}) do |(key, val), new|
        new[to_snake_case(key.to_s).to_sym] = convert_hash_keys(val)
      end
      result
    end

    def self.to_snake_case(string)
      string.gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .downcase
    end
  end
end
