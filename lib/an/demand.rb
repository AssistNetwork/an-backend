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

  def initialize
    # generate ID:=nodeID + DemandID
  end

end