require 'ohm'
require 'ohm/contrib'

class Supply < Ohm::Model
  include Ohm::Timestamps

  attribute :network
  attribute :id
  attribute :what   # mit: a szokásos command
  attribute :start  # mettől
  attribute :end    # meddig
  attribute :where  # hol?
  attribute :reason

  def initialize
    @network = :an
  end

end