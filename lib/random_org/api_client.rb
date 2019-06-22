# frozen_string_literal: true

require 'random_org/wrong_api_key_error'
require 'random_org/api_server_error'
require 'rest-client'

module RandomOrg
  # The API client responsible for making all the calls.
  #
  # @api private
  class ApiClient
    # Constructs a request to the API
    # @param [Symbol] which_request request to build
    # @param [Hash,nil] args arguments
    # @return [Hash] prebuilt request
    def self.build_request(which_request, args = nil)
      req = base_request
      req[:params] = args.merge('apiKey' => RandomOrg.configuration.api_key)

      req[:method] = setup_request_method(which_request)

      req
    end

    # Performs a request to the API
    # @param [Hash] req prebuilt request to perform
    # @return [Hash] parsed response
    def self.perform_request(req)
      response = RestClient.post(@endpoint_uri, req.to_json,
                                 content_type: 'application/json')
      case response.code
      when 400
        wrong_api_key_error
      when 500
        api_server_error
      end
      response.code == 200 ? JSON.parse(response.body) : nil
    end

    @endpoint_uri = 'https://api.random.org/json-rpc/2/invoke'

    private_class_method def self.base_request
      {
        jsonrpc: '2.0',
        id: 1 + (Random.rand * 9999).to_i
      }
    end

    private_class_method def self.setup_request_method(which_request)
      case which_request
      when :generate_integers
        'generateIntegers'
      when :generate_integer_sequences
        'generateIntegerSequences'
      when :generate_decimal_fractions
        'generateDecimalFractions'
      when :generate_blobs
        'generateBlobs'
      when :generate_uuids
        'generateUUIDs'
      end
    end

    def self.process_response(response)
      bad_response_error(response) unless response.key? 'result'
      result = response['result']
      bad_response_error(response) unless result.key? 'random'
      random = result['random']
      bad_response_error(response) unless random.key? 'data'
      random['data'].first
    end

    def self.bad_response_error(response)
      raise ApiError, "Something is wrong with the response: #{response}"
    end

    private_class_method def self.api_server_error
      raise ApiServerError, 'Something went wrong from the random.org API. ' \
                            'Try again or check their service for information.'
    end

    private_class_method def self.wrong_api_key_error
      raise WrongApiKeyError, 'Wrong or missing API key, ' \
                              'check your configuration.'
    end
  end
end
