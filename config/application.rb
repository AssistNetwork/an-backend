# Setup sane defaults
ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require_relative '../lib/an_configuration.rb'
require_relative '../lib/an_logger.rb'
Dir[File.expand_path('initializers/**/*.rb', __dir__)].reduce(self, :require)
Dir[File.expand_path('../app/api/v1/**/*.rb', __dir__)].reduce(self, :require)
require_relative '../app/api/v1.rb'

module AN
  class << self
    def app
      Rack::Builder.new do
        run ::AN::V1
      end
    end

    def initialize! **options
    end
  end
end
