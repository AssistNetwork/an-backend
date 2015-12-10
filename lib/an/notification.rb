class Notification < Ohm::Model
  include Ohm::Timestamps

  attribute :cmd     # szokásos command : d - demand, s - supply, o - offer, m - message, , i

  attribute :data  # data

  attribute :event
  attribute :state

  reference :node, :Node

  def Initialize( node, cmd, data, event)
    self.node = node
    self.cmd = cmd
    self.node = data
    self.cmd = event
    self.save
  end

  def to_hash
    {:id => id.to_i}.merge(@attributes)
  end

end