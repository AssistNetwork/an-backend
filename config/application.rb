# Setup sane defaults
# Builds Rack APP

ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require 'logger'

require 'ohm'
require_relative '../lib/an/service'
require_relative '../lib/an/node'
require_relative '../lib/an/user'

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

    def test_data
      Ohm.redis = Redic.new(@configuration.redis)
      Ohm.redis.call("FLUSHALL")

      @path = Pathname(File.expand_path(File.dirname(__FILE__)) + '/../test/data' )

      @srv = Service.create JSON.parse(File.read( @path +'service.json'))
      @srv.save
      @node1 = Node.create JSON.parse(File.read( @path + 'node1.json'))
      @node1.save
      @node2 = Node.create JSON.parse(File.read( @path + 'node2.json'))
      @node2.save
      @user1 = User.create JSON.parse(File.read( @path + 'user1.json'))
      @user1.save
      @user2 = User.create JSON.parse(File.read( @path + 'user2.json'))
      @user2.save
      @user3 = User.create JSON.parse(File.read( @path + 'user3.json'))
      @user3.save

      @node1.register_profile(@user1)
      @node1.register_profile(@user2)
      @node2.register_profile(@user3)
      @node1.save
      @node2.save
    end



    def initialize!(**options)
      @configuration
      test_data # minden indulásnál üres db-vel fog indulni
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

