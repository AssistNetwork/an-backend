Dir[File.expand_path('helpers/**/*.rb', __dir__)].reduce(self, :require)

class TestConfig < APITest


  def test_service
    srv = Service[1]
    assert srv.name, 'assist-network'
    assert srv.network, 'an'
    srv.register_node @node1
    srv.register_node @node2
    assert srv.registrations[1], @node1
    assert srv.registrations[2], @node2
    srv.deregister_node @node1
    assert srv.registrations.size, 1
    assert srv.registrations[2], @node2
    srv.deregister_node @node2
    assert srv.registrations.size, 0
  end

  def test_node
    srv = Service[1]
    @node1.register_to_service srv
    assert srv.registrations[1], @node1
    @node2.register_to_service srv
    assert srv.registrations[2], @node2
  end

end