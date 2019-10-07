# frozen_string_literal: true

module RandomOrg
  module Response
    # Usage response from Random.org API.
    #
    # @version 0.2.2
    # @author Jan Lindblom <janlindblom@fastmail.fm>
    # @!attribute [r] status
    #   @return [String] a string indicating the API key's current status,
    #     which may be +stopped+ or +running+. An API key must be running for
    #     it to be able to serve requests.
    # @!attribute [r] creation_time
    #   @return [DateTime] the timestamp at which the API key was created.
    # @!attribute [r] bits_left
    #   @return [Integer] an integer containing the (estimated) number of
    #     remaining true random bits available to the client.
    # @!attribute [r] requests_left
    #   @return [Integer] an integer containing the (estimated) number of
    #     remaining API requests available to the client.
    # @!attribute [r] total_bits
    #   @return [Integer] an integer containing the number of bits used by this
    #     API key since it was created.
    # @!attribute [r] total_requests
    #   @return [Integer] an integer containing the number of requests used by
    #     this API key since it was created.
    class Usage
      attr_reader :status
      attr_reader :creation_time
      attr_reader :bits_left
      attr_reader :requests_left
      attr_reader :total_bits
      attr_reader :total_requests

      # Initialize a new Usage object.
      def initialize(args = {})
        create_from_hash args
      end

      private

      def create_from_hash(args)
        @status = args['status'] if args.key? 'status'
        @creation_time = DateTime.parse(args['creationTime']) if args.key? 'creationTime'
        @bits_left = args['bitsLeft'] if args.key? 'bitsLeft'
        @requests_left = args['requestsLeft'] if args.key? 'requestsLeft'
        @total_bits = args['totalBits'] if args.key? 'totalBits'
        @total_requests = args['totalRequests'] if args.key? 'totalRequests'
      end

      def expected_keys
        %w[status creationTime bitsLeft requestsLeft totalBits totalRequests]
      end
    end
  end
end
