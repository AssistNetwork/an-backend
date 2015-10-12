require 'grape'
require 'rack/cors'

require_relative '../../lib/an'

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

    use Rack::Session::Cookie, secret: ::AN.configuration.session_secret

    desc 'Returns current API version and environment.'
    get do
      { version: 'v1', environment: ENV['RACK_ENV'] }
    end

    resource :demand

    desc 'Returns current demands.'

    get :list do
      p 'demand/list'
    end

    desc 'Returns current API version and environment.'

    post do
      { version: 'v1', environment: ENV['RACK_ENV'] }
    end

  end
end
