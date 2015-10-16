require 'test_helper'
require 'ohm'
require 'ohm-zset'
require 'ohm/contrib'
require_relative '../lib/an'

class TestModel < Minitest::Test

  def setup
    Ohm.redis = Redic.new ('redis://localhost:6379')
    Ohm.redis.flushall

  end

  def test_demand
    demand = Demand.new
    demand.network = 'an'
    attribute :id
    attribute :what     # mit: a szokásos command
    attribute :start    # mettől
    attribute :end      # meddig
    attribute :where    # hol?
    attribute :reason
    attribute :state
    attribute :parentid

  end

  def test_supply

  end

  def test_offer

  end

  def test_delivery

  end

  def test_node

  end


end