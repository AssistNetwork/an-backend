require 'logger' #TODO szabványos Grape logger
#require 'ohm'
require 'ohm/stateful_model'

class OfferStates < Ohm::State

  state_machine :state, :initial => :created do

    event :approve do
      transition :created => :approved
    end

    event :dispatched do
      transition :approved => :load
    end

    event :loaded do
      transition :load => :track_transport
    end

    event :transport_event do
      transition :track_transport => same
    end

    event :transport_arrived do
      transition :track_transport => :unload
    end

    event :unloaded do
      transition :unload => :confirm
    end

    event :confirm do
      transition :confirm => :closed
    end

  end

end