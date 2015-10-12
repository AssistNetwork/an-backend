require 'ohm'
require 'ohm-zset'


class Node < Ohm::Model

  attribute :name
  attribute :phone
  attribute :email
  unique :email

  zset :demands, :Demand
  zset :supplies, :Supply

end
