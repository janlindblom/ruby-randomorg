module RandomOrg
  module Response
    class Usage
      attr_reader :status
      attr_reader :creation_time
      attr_reader :bits_left
      attr_reader :requests_left
      attr_reader :total_bits
      attr_reader :total_requests

      def initialize(args={})
        @status = args['status'] if args.key? 'status'
        @creation_time = args['creationTime'] if args.key? 'creationTime'
        @bits_left = args['bitsLeft'] if args.key? 'bitsLeft'
        @requests_left = args['requestsLeft'] if args.key? 'requestsLeft'
        @total_bits = args['totalBits'] if args.key? 'totalBits'
        @total_requests = args['totalRequests'] if args.key? 'totalRequests'
      end
    end
  end
end
