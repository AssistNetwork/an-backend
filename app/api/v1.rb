require 'grape'
require 'rack/cors'

module AN
  class V1 < ::Grape::API
    prefix 'api'
    format :json
    version %w{ v1 }, using: :header, vendor: 'assist-network', format: :json

    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :delete]
      end
    end

    use Rack::Session::Cookie, secret: ::AN.configuration.secret_token

    desc 'Returns current API version and environment.'
    get do
      { version: 'v1', environment: ENV['RACK_ENV'] }
    end
  end
end
