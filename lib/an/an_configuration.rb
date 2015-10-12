# Provides configuration capabilities.
module AN
  class << self
    attr_reader :configuration

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end
  end

  class Configuration
    # It is used for session token cryptography and redis configuration
    attr_accessor :session_secret
    attr_accessor :redis
  end
end
