require 'minitest/autorun'

require 'minitest/reporters' # requires the gem

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'net/http'
require 'ohm'




ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require_relative '../config/application.rb'
#Dir[File.expand_path('helpers/**/*.rb', __FILE__)].reduce(self, :require)


require_relative '../lib/an/service'


class TestConfigData < Minitest::Test
#  include AN::Test::API

  def setup
    Ohm.redis.flushall
    AN.initialize!
  end

  def service_config

    srv = Service.create File.read('object.json')
    srv.save

    p "id = #{srv.id}"

    srv.all.each do |i|
      p i.name.to_s + ":" + i.object_id.to_s
    end

    p srv.class.ancestors

    @http = Net::HTTP.new('localhost', 9292)
    @path = 'api/object'
    @headers = {'Content-Type' => 'application/json'}

    resp = @http.post(@path, data, @headers)
    print resp.body
    #resp.body.must_equal "{object: '#{data.to_s}', success: true}"
  end

end