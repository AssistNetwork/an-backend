require 'logger'

# We must rename this file from 'logger.rb' to 'an_logger.rb' due to clashing
# with Ruby's internal 'logger.rb'.
module AN
  class << self
    def logger
      @logger ||= heroku? ? ::Logger.new(STDOUT) : ::Logger.new(File.expand_path("../../log/#{ENV["RACK_ENV"]}.log", __dir__))
    end
  end
end
