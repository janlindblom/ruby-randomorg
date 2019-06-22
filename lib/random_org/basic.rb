require 'random_org/api_client'
require 'random_org/argument_error'

module RandomOrg
  class Basic
    class << self

      def generate_integers(args = nil)
        raise RandomOrg::ArgumentError.new("Missing required arguments.") if args.nil?
        req = RandomOrg::ApiClient.build_request(:generate_integers, args)
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::ApiClient.process_response(response)
      end

      def generate_integer_sequences(args = nil)
        raise RandomOrg::ArgumentError.new("Missing required arguments.") if args.nil?
        req = RandomOrg::ApiClient.build_request(:generate_integer_sequences, args)
        response = RandomOrg::ApiClient.perform_request(req)
        RandomOrg::ApiClient.process_response(response)
      end
    end
  end
end
