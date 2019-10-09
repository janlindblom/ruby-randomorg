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
    # @param [String] api_method request to build
    # @param [Hash,nil] args arguments
    # @return [Hash] prebuilt request
    def self.build_request(api_method, args = nil)
      req = base_request
      req[:params] = args.merge('apiKey' => RandomOrg.configuration.api_key)
      req[:method] = api_method
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

    # Process the API response from the random.org API call.
    #
    # @param [Hash] response the response to the request
    # @return [Hash] the returned data object
    def self.process_response(response, expect_random_data = true)
      bad_response_error(response) unless response.key? 'result'
      result = response['result']
      return result unless expect_random_data

      bad_response_error(response) unless result.key? 'random'
      random = result['random']
      bad_response_error(response) unless random.key? 'data'
      #random['data'].first
      random
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
