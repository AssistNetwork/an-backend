require 'ohm'

class Location  < Ohm::Model
  include Ohm::Timestamps

  attribute :name
  attribute :country
  attribute :zipCode
  attribute :city
  attribute :street
  attribute :streetType
  attribute :streetNumber
  attribute :gps_longitude
  attribute :gps_latitude

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end

  def to_map
    # TODO find a map position by gps, or vica
  end

end
