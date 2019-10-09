# frozen_string_literal: true

require 'random_org/response/usage'
require 'random_org/response/integers'
require 'random_org/response/integer_sequences'

module RandomOrg
  # An API response as an object.
  #
  # @version 0.2.2
  # @author Jan Lindblom <janlindblom@fastmail.fm>
  module Response
    def self.convert_hash_keys(value)
      return value unless (value.is_a?(Hash))
      result = value.inject({}) do |new, (key, value)|
        new[to_snake_case(key.to_s).to_sym] = convert_hash_keys(value)
        new
      end
      result
    end

    def self.to_snake_case(string)
      string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
  end
end
