require 'ohm'
require 'ohm/contrib'

class Supply < Ohm::Model
  include Ohm::Timestamps

  attribute :msgid
  attribute :what   # mit: a szokásos command
  set :attrs, Array # attributumok
  attribute :qty  #mennyiség
  attribute :unit  # egység
  attribute :end      # meddig
  attribute :long    # hol long
  attribute :lat     # hol lat
  attribute :start  # mettől
  attribute :end    # meddig
  attribute :reason
  attribute :state
  attribute :parentid

  reference :node, :Node

  unique :msgid
  index  :parentid

#  def initialize
#    super
#    @network = :an
#  end

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end

end