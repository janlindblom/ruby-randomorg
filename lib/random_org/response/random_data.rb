# frozen_string_literal: true

require 'random_org/response/data'

module RandomOrg
  module Response
    # Generic random data response from Random.org API.
    #
    # @version 0.2.2
    # @author Jan Lindblom <janlindblom@fastmail.fm>
    # @!attribute [rw] data
    #   @return [Array] an array containing the sequence of numbers requested.
    # @!attribute [rw] completion_time
    #   @return [DateTime] the timestamp at which the request was completed.
    class RandomData < Data
      attr_accessor :data
      attr_reader :completion_time

      def initialize(args = {})
        convert_hash_keys(args).each { |k, v| public_send("#{k}=", v) }
      end

      def completion_time=(completion_time)
        @completion_time = if completion_time.is_a? String
                             DateTime.parse completion_time
                           else
                             completion_time
                           end
      end
    end
  end
end
