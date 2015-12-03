require 'ohm'
require 'ohm/contrib'
#require 'ohm-zset'

class Demand < Ohm::Model
  include Ohm::Timestamps

  attribute :msgid    # kliens által adott msgid
  attribute :what     # mit: a szokásos command
#  set :attrs, Array  # attributumok
#  set :attrsnot, Array # attributumok amik nem, supplyban nincs
  attribute :attrs
  attribute :attrsnot

  attribute :qty   # mennyiség
  attribute :unit  # egység
  attribute :end      # meddig
  attribute :long    # hol long
  attribute :lat    # hol lat
  attribute :start  # mettől
  attribute :end    # meddig

  attribute :reason
  attribute :state
  attribute :parentid

  reference :node, :Node
#  reference :user, :User

  index :msgid
  index :parentid

#  def initialize
#    super
#    # generate ID:=nodeID + DemandID - majd ha kell
#  end


  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end


end