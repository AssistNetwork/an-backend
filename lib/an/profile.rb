require 'ohm'

class Profile < Ohm::Model

  attribute :created
  index :created
  reference :node, :Node
  reference :user, :User
#  reference :node, :Node # Todo Service/Node-e amire vonatkozik a scope? így a Service/Node az authorizációs pont
  attribute :scope

end