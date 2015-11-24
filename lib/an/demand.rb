require 'ohm'
require 'ohm/contrib'

class Demand < Ohm::Model
  include Ohm::Timestamps

  attribute :msgid    # kliens által adott msgid
  attribute :what     # mit: a szokásos command
  attribute :start    # mettől
  attribute :end      # meddig
  attribute :where    # hol?
  attribute :reason
  attribute :state
  attribute :parentid

  reference :node, :Node
#  reference :user, :User

  index :msgid
  index  :parentid

#  def initialize
#    super
#    # generate ID:=nodeID + DemandID - majd ha kell
#  end

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end

end