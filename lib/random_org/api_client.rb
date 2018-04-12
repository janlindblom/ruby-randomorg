require 'rest-client'
require 'random_org/wrong_api_key_error'
require 'random_org/api_server_error'

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

      case which_request
      when :generate_integers
        req[:method] = 'generateIntegers'
      when :generate_decimal_fractions
        req[:method] = 'generateDecimalFractions'
      when :generate_blobs
        req[:method] = 'generateBlobs'
      when :generate_uuids
        req[:method] = 'generateUUIDs'
      end

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
        raise WrongApiKeyException, 'Wrong or missing API key, check your configuration.'
      when 500
        raise ApiServerException, 'Something went wrong from the random.org API. Try again or check their service for information.'
      else
        return nil
      end
    end

    @endpoint_uri = 'https://api.random.org/json-rpc/1/invoke'

    private_class_method def self.base_request
      {
        jsonrpc: '2.0',
        id: 1 + (Random.rand * 9999).to_i
      }
    end
  end
end
