# Setup sane defaults
# Builds Rack APP

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require 'logger'

module AN
  class << self

    attr_reader :configuration

    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end

    def logger
      @logger ||= heroku? ? ::Logger.new(STDOUT) : ::Logger.new(File.expand_path("../log/#{ENV['RACK_ENV']}.log", __dir__))
      @logger.info 'started'
    end

    def initialize!(**options)
      @configuration
    end

    def heroku?
      ENV.keys.any? { |v| v.match(/heroku|dyno/i) }
    end

    def environment
      (ENV['RACK_ENV'] || 'development').to_sym
    end

    def production?
      environment == :production
    end

    def development?
      environment == :development
    end

    def test?
      environment == :test
    end
    alias testing? test?

    def app

      # --API modules
      Dir[File.expand_path('../app/api/**/*.rb', __dir__)].reduce(self, :require)

      Rack::Builder.new do

        run ::AN::V1
      end

    end

  end

  class Configuration
    # It is used for session token cryptography and redis configuration
    attr_accessor :session_secret
    attr_accessor :redis


  end


end

