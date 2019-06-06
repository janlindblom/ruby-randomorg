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
      response = RestClient.post(@endpoint_uri, req.to_json)
      case response.code
      when 200
        return JSON.parse(response.body)
      when 400
        wrong_api_key_error
      when 500
        api_server_error
      end
      nil
    end

    @endpoint_uri = "https://api.random.org/json-rpc/2/invoke"

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
      when :generate_decimal_fractions
        'generateDecimalFractions'
      when :generate_blobs
        'generateBlobs'
      when :generate_uuids
        'generateUUIDs'
      end
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
