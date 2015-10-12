require 'rack/test'

module AN
  module Test
    module API
      def included into
        into.include Minitest::Assertions
        into.extend ClassMethods
      end

      module ClassMethods
      end

      def app
        @app ||= RackApp.new
      end

      %w{ get post put delete options }.each do |method|
        define_method(method) do |path, params={}, headers={}|
          response = app.send(method, path, params, headers)
          RackResponse.new(response)
        end
      end

      class RackApp
        include Rack::Test::Methods
        def app version='v1'
          AN.const_get(version.upcase)
        end
      end

      class RackResponse
        attr_reader :response
        delegate :status, :headers, to: :response
        def initialize response
          @response = response
        end

        def json
          @json ||= @response.body.empty? ? nil : JSON.parse(@response.body)
        end
      end
    end
  end
end
