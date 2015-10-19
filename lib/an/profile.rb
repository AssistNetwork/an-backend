require 'ohm'

class Profile < Ohm::Model

  reference :user, :User
  reference :node, :Node # Todo Service/Node-e amire vonatkozik a scope? így a Service/Node az authorizációs pont
  attribute :scope

end