module AN
  class << self
    attr_reader :configuration

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end
  end

  class Configuration
    # It is used for session token cryptography.
    attr_accessor :secret_token
  end
end
