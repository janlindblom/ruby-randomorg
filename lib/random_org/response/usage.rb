# frozen_string_literal: true

module RandomOrg
  module Response
    # Usage response from Random.org API.
    #
    # @version 0.2.2
    # @author Jan Lindblom <janlindblom@fastmail.fm>
    # @!attribute [rw] status
    #   @return [String] a string indicating the API key's current status,
    #     which may be +stopped+ or +running+. An API key must be running for
    #     it to be able to serve requests.
    # @!attribute [rw] creation_time
    #   @return [DateTime] the timestamp at which the API key was created.
    # @!attribute [rw] bits_left
    #   @return [Integer] an integer containing the (estimated) number of
    #     remaining true random bits available to the client.
    # @!attribute [rw] requests_left
    #   @return [Integer] an integer containing the (estimated) number of
    #     remaining API requests available to the client.
    # @!attribute [rw] total_bits
    #   @return [Integer] an integer containing the number of bits used by this
    #     API key since it was created.
    # @!attribute [rw] total_requests
    #   @return [Integer] an integer containing the number of requests used by
    #     this API key since it was created.
    class Usage
      attr_accessor :status
      attr_accessor :creation_time
      attr_accessor :bits_left
      attr_accessor :requests_left
      attr_accessor :total_bits
      attr_accessor :total_requests

      # Initialize a new Usage object.
      def initialize(args = {})
        Response.convert_hash_keys(args).each {|k,v| public_send("#{k}=",v)}
      end

      def creation_time=(creation_time)
        if creation_time.is_a? String
          @creation_time = DateTime.parse creation_time
        else
          @creation_time = creation_time
        end
      end
    end
  end
end
