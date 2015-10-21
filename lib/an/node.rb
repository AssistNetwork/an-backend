require 'ohm'
#require 'ohm-zset' # TODO kell-e majd?

require_relative 'demand'
require_relative 'supply'
require_relative 'offer_flow'
require_relative 'event'



class Node < Ohm::Model

  attribute :name
  unique :name
  attribute :location

  collection :registrations, :Registration
#  attribute :phone
#  attribute :email
#  unique :email
  attribute :with_transport


  attribute :store

  set :demands, :Demand
  set :supplies, :Supply
  set :offers, :OfferFlow
  set :events, :Event

  def register_to_service(service)
    # generate ID:= :network + unique ID (global a network-re)
    unless service.nil?
      self.save
      service.register_node self
    end
  end

  def derregister_from_service(service)
    # generate ID:= :network + unique ID (global a network-re)
    service.deregister_node self
  end

  def login
    # TODO: így a userek <> node, azaz lehet több user is ugyanahoz a node-hoz rendelve // OAuth2??? csináljuk rendesen :)
    # authorize!
  end

  def logout

  end

  def set_profile
     # set name,phone,email
  end

  def add_demand (demand)
    # ADD Node.demands[]
    self.demands.add (Demand.create(demand))
  end

  def list_demands (filter='')
    demands = self.demands.find(filter)
  end

  def approve_offer (with_transport = @with_transport)
    demand_fulfill(offer)
  end

  def collect_offer  (offer)
    # generate Transport Task to the offered.items

  end

  def add_supply (supply)
    #supply = Supply.new()
    self.supplies.add (Supply.create(supply))
  end

  def list_supplies (filter='')
    supplies = self.supplies.find(filter)
  end

  def attribute_type (cmd)
    case cmd
      when 'd'
        self.demands
      when 's'
        self.supplies
    end
  end

  def to_hash
    hash= {:id => id.to_i}.merge(@attributes)
    hash.merge!({:service => service.to_hash}) unless service.nil?
    {:id => id.to_i, :demands => demands.to_a.map{|e| e.to_hash}}.merge(@attributes)
    {:id => id.to_i, :supplies => supplies.to_a.map{|e| e.to_hash}}.merge(@attributes)
    {:id => id.to_i, :offers => offers.to_a.map{|e| e.to_hash}}.merge(@attributes)
    #hash.merge(@demands)
    #hash.merge(@supplies)
    #hash.merge(@offers)
    #hash.merge(@events)
  end

  private

  def demand_fulfill (offer)
    # if offer < demand then
    #   demand_fulfill(split_demand (demand-offer.supplies)
    # end
    #
  end

  def refresh_store

  end

  def split_demand
    # create_demand (offer.demand - offer.supplies)
  end

end
