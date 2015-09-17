# Builds Rack APP
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
