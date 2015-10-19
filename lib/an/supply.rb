require 'ohm'
require 'ohm/contrib'

class Supply < Ohm::Model
  include Ohm::Timestamps

  attribute :msgid
  attribute :what   # mit: a szokásos command
  attribute :start  # mettől
  attribute :end    # meddig
  attribute :where  # hol?
  attribute :reason

  def initialize
    @network = :an
  end

end