require 'ohm'
require 'ohm-zset'

require_relative 'demand'
require_relative 'supply'
require_relative 'offer_flow'
require_relative 'event'



class Node < Ohm::Model

  attribute :network
  attribute :id
  attribute :name
  attribute :location

  reference :service, :Service
#  attribute :phone
#  attribute :email
#  unique :email
  attribute :with_transport


  attribute :store

  zset :demands, :Demand
  zset :supplies, :Supply
  zset :offers, :OfferFlow
  zset :events, :Event

  def register
    # generate ID:= :network + unique ID (global a network-re)
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

  def create_demand

  end

  def approve_offer (with_transport = @with_transport)
    demand_fulfill(offer)
  end

  def collect_supply

  end

  def create_supply (params)
    #supply = Supply.new(params)
  end

  def to_hash
    hash= {:id => id.to_i}.merge(@attributes)
    hash.merge(@demands)
    hash.merge(@supplies)
    hash.merge(@offers)
    hash.merge(@events)
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
