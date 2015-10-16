#TODO szabványos Grape logger
#require 'ohm'
require 'ohm/stateful_model'

require_relative 'delivery_flow'
require_relative 'event'

class DeliveryStates < Ohm::State

  state_machine :state, :initial => :created do

    event :approve do
      transition :created => :approved
    end

    event :start do
      transition :approved => :started
    end

    event :transport_event do
      transition :track_transport => same
    end

    event :end do
      transition :track_transport => :end
    end

    event :confirm do
      transition :end => :closed
    end

  end
end