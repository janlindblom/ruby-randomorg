# frozen_string_literal: true

module RandomOrg
  module Response
    # Generic data response object class.
    #
    # @version 0.2.2
    # @author Jan Lindblom <janlindblom@fastmail.fm>
    class Data
      private

      def convert_hash_keys(value)
        return value unless value.is_a?(Hash)

        value.each_with_object({}) do |(key, val), new|
          new[to_snake_case(key.to_s).to_sym] = convert_hash_keys(val)
        end
      end

      def to_snake_case(string)
        string.gsub(/::/, '/')
              .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
              .gsub(/([a-z\d])([A-Z])/, '\1_\2')
              .tr('-', '_')
              .downcase
      end
    end
  end
end
