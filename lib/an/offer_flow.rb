require 'ohm'
require 'ohm/contrib'
require 'ohm-zset'
require 'ohm/stateful_model'

require_relative 'supply'
require_relative 'demand'
require_relative 'offer_states'


class OfferFlow < Ohm::StatefulModel
  include Ohm::Timestamps

  use_state_machine OfferStates, :attribute_name => :current_state

  #attribute :flowid
  attribute :last_error
  reference :demand,:Demand
  zset :supplies, :Supply

  def initialize (demand, supplies)
    @demand = demand
    supplies.each do |s|
      @supplies.add s
    end
  end

  def approve
    fire_state_event(:approve)
  end

end