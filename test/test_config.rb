require 'minitest/autorun'
require 'ohm'
require 'json'


ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require_relative '../config/application.rb'
#Dir[File.expand_path('helpers/**/*.rb', __FILE__)].reduce(self, :require)

require_relative '../lib/an'


class TestConfig < Minitest::Test
#  include AN::Test::API

  def setup
    Ohm.redis = Redic.new("redis://127.0.0.1:6379")
    Ohm.redis.call("FLUSHALL")
    config
  end

  def config


    @srv = Service.create JSON.parse(File.read('data/service.json'))
    @srv.save

    #p "id = #{@srv.id}"
    #p @srv.class.ancestors

    @node1 = Node.create JSON.parse(File.read('data/node1.json'))
    @node1.save
    @node2 = Node.create JSON.parse(File.read('data/node2.json'))
    @node2.save

  end

  def test_service
    srv = Service[1]
    assert srv.name, 'assist-network'
    assert srv.network, 'an'
    srv.register_node @node1
    srv.register_node @node2
    assert srv.registrations[1], @node1
    assert srv.registrations[2], @node2
    srv.deregister_node @node1
    assert srv.registrations.size, 1
    assert srv.registrations[2], @node2
    srv.deregister_node @node2
    assert srv.registrations.size, 0
  end

  def test_node
    srv = Service[1]
    @node1.register_to_service srv
    assert srv.registrations[1], @node1
    @node2.register_to_service srv
    assert srv.registrations[2], @node2
  end

end