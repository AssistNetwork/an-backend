require 'ohm'
require_relative 'registration'
require 'time'

class Service < Ohm::Model

  attribute :name
  unique :name
  attribute :network
  unique :network

  set :registrations, :Registration
#  collection :connection, :Connection


  def register_node (node)

    if !node.nil? and self.registrations[node.id].nil?
      reg = Registration.create(created: Time.now.to_s)
      reg.update(node:node)
      self.registrations.add reg
      self.save
    end
  end

  def unregister_node (node)
    if !self.registrations.nil? and !node.nil?
      self.registrations[node.id].delete
      self.save
      TRUE
    else
      NIL
    end
  end

  def list_nodes
    self.registrations unless !self.registrations.nil?
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

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end

end