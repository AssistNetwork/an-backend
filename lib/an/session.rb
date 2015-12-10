class Session < Ohm::Model
  include Ohm::Timestamps

  attribute :auth_token
  index :auth_token

  attribute :end

  attribute :state

  set :nodes, :Node

  reference :user, :User


# unique :auth_token # Majd felélesztjük, ha valós session kezelés van... jelenleg 1uses-1node-1session


  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end


end