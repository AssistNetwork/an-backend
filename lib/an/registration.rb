require 'ohm'

class Registration < Ohm::Model

  attribute :created
  index :created
  reference :node, :Node

end