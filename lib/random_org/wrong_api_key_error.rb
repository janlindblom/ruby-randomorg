module RandomOrg
  # Raised when the API returns an error due to a nonexisting API key.
  class WrongApiKeyError < StandardError
  end
end
