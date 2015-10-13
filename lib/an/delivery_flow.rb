require 'ohm'
require 'ohm/contrib'
require 'ohm-zset'
require 'ohm/stateful_model'


require_relative 'location'
require_relative 'offer_flow'
require_relative 'event'

class DeliveryFlow < Ohm::StatefulModel
  include Ohm::Timestamps

  use_state_machine DeliveryStates, :attribute_name => :current_state
  attribute :last_error

  zset :offers, :OfferFlow
#  zset :events, :Event, :created_at

  def add_offer(offer)
    @offers.add(offer) if current_state = :created
  end

  def delete_offer(offer)
    @offers.del(offer) if current_state = :created
  end

  #TODO eventeket rendbe tenni

  def delivery_approve
    fire_state_event(:approve)
  end

  def delivery_start
    fire_state_event(:start)
  end

  def offer_load(offer)
    offer.fire_state_event(:load)
  end

  def transport_event(event)
    success = update_delivery(:transport_event)
    if success
      begin
        #
        @attributes[:last_error] = nil
        save
        events.add(Event.create(type: 'track'))
        fire_state_event(:track_event)
      rescue StandardError => error
        handle_error(error, event)
      end
    end
    success
  end

  def offer_unload(offer)
    offer.fire_state_event(:unload)
  end

  def delivered(event)
    unless can_delivered?
      return false
    end
    begin
      #
      @attributes[:last_error] = nil
      save
      fire_state_event(:delivered)
      @events.add(Event.create(type: 'closed'))
      fire_state_event(:closed)
    rescue StandardError => error
      handle_error(error, event)
    end
  end

  private

  def handle_error(error, event)
    error_event = Event.create(type: event.attributes)
    events.add(error_event)
    @attributes[:last_error] = error.message
    save
    Logger.new(STDERR).error(error.message + "\n" + error.backtrace.join("\n"))
    false
  end
  
  def to_hash
    hash = {:id => id.to_i}.merge(@attributes)
    hash.merge(@offers)
    hash.merge(@events)
  end

end
