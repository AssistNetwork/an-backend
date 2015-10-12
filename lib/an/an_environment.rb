# Checks whether we are running on Heroku or not.  Also provides some
# environment helpers.
module AN
  class << self
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
  end
end
