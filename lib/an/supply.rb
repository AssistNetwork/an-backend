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
  attribute :state
  attribute :parentid

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