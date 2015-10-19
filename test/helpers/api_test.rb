ENV['RACK_ENV'] = 'test'

require 'grape'
require 'json'
require 'minitest'
require 'minitest/autorun'
require 'rack/test'
require 'logger'
require_relative '../../config/application'

Grape::API.logger = Logger.new('/dev/null')


class ApiTest
  include MiniTest::Assertions

  attr_accessor :rack_test

  def initialize
    self.rack_test = ::ApiTest::RackTest.new
  end

  %w(get post put delete).each do |method|
    define_method(method) do |path, params={}, headers={}|
      JsonResponse.new(rack_test.send(method, path, params, headers))
    end
  end

  class RackTest
    include Rack::Test::Methods

    def app
      AN::API
    end
  end

  class JsonResponse
    attr_reader :response
    delegate :status, :headers, to: :response

    def initialize(response)
      @response = response
    end

    def body
      @body ||= begin
        @response.body.empty?? @response.body : JSON.parse(@response.body)
      end
    end
  end
end

class AnTest < MiniTest::Test

  def setup
    Ohm.redis = Redic.new("redis://127.0.0.1:6379")
    Ohm.redis.call("FLUSHALL")
    AN.initialize!
    @client = ApiTest.new
  end

  

end