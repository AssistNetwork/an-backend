require 'ohm'
require 'ohm/contrib'

class Demand < Ohm::Model
  include Ohm::Timestamps

  attribute :network
  attribute :id
  attribute :what     # mit: a szokásos command
  attribute :start    # mettől
  attribute :end      # meddig
  attribute :where    # hol?
  attribute :reason
  attribute :state
  attribute :parentid

  def initialize
    @network = :an
    # generate ID:=nodeID + DemandID
  end

end