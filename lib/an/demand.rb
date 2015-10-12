require 'ohm'
require 'ohm/contrib'

class Demand < Ohm::Model
  include Ohm::Timestamps

  attribute :network
  attribute :node
  attribute :what     # mit: a szokásos command
  attribute :start    # meddig?
  attribute :end      # meddig
  attribute :where    # hol?
  attribute :reason

  def initialize
    @network = :an
  end

end