require 'ohm'
require 'ohm/contrib'

class Event < Ohm::Model
  include Ohm::Timestamps

  attribute :type
  index     :type
  attribute :message
  attribute :gps_longitude # TODO location kezelés rendesen
  attribute :gps_latitude

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end

end