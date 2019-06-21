# frozen_string_literal: true

module RandomOrg
  # Holds configuration of the module required for it to work.
  class Configuration
    # Sets the random.org API key.
    # @return [String]
    attr_accessor :api_key

    def initialize
      @api_key = ''
    end
  end
end
