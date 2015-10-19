require 'ohm'

class User < Ohm::Model

  attribute :name
  unique :name
  attribute :email
  unique :email
  attribute :salt

  collection :profiles, :Profile


end
