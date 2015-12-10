class Session < Ohm::Model
  include Ohm::Timestamps

  attribute :auth_token     # mit: a szokásos command

  attribute :start  # mettől
  attribute :end    # meddig

  attribute :state

  collection :nodes, :Node
  reference :user, :User

  index :auth_token
# unique :auth_token # Majd felélesztjük, ha valós session kezelés van... jelenleg 1uses-1node-1session

  def Initialize(auth_token)
    @auth_token = auth_token

  end

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end


end