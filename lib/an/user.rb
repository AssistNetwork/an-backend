require 'ohm'

class User < Ohm::Model

  attribute :name
  index :name
  attribute :email
  unique :email

  attribute :auth_token
  unique :auth_token

  attribute :uid
  unique :uid
  #attribute :salt

  #collection :profiles, :Profile

  def checkin(node)
    node.checkin self
  end

  def checkout(node)
    node.checkout self
  end

end
