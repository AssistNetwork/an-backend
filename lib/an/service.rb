require 'ohm'
require 'ohm-zset'

require_relative 'demand'
require_relative 'supply'
require_relative 'offer_flow'
require_relative 'event'

class Service < Ohm::Model

  attribute :name
  attribute :network

  zset :nodes, :Node

=begin
  def add_node (node)
    @nodes.add node if node.network == @network
  end

  def del_node (node)
    @nodes.del node
  end

  def generate_offers # ezt kell majd jól optimalizálni
    nodes.each do |node|
      node.demands.each do |demand|
        if demand.state = :open
          OfferFlow.new( demand, supplies(node.location, demand.what))
        end
      end
    end
  end

  def supplies (location, what)
    nodes.find?(near(:location => location)).each do |n|
      n.supplies.each do |s|
        if same_kind_of( s.what, what )

        end
      end
    end
  end
=end
end