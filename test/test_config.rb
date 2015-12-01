Dir[File.expand_path('helpers/**/*.rb', __dir__)].reduce(self, :require)

class TestConfig < APITest

  def setup
    @node1 = Node[1]
    @node2 = Node[2]
    @srv = Service[1]
    @user1 = User[1]
    @user2 = User[2]
    @user3 = User[3]
  end

  def test_service

    assert @srv.name, 'assist-network'
    assert @srv.network, 'an'
    @srv.register_node @node1
    @srv.register_node @node2
    @node3 = Node.create(name: '3' , location: 'loc2')
    @node4 = Node.create(name: '4' , location: 'loc1')
    @srv.register_node @node3
    @srv.register_node @node4
    assert_equal @srv.registrations[1].node, @node1
    assert_equal @srv.registrations[2].node, @node2
    @srv.unregister_node @node3
    assert_equal @srv.registrations[3], NIL # töröltük a node1 regisztrációját
    assert_equal @srv.registrations.size, 4 # az array size marad 2!
    assert_equal @srv.registrations[2].node, @node2
    @srv.unregister_node @node4
    assert @srv.registrations.size, 2
  end

  def test_node
    @srv = Service[1]
    @node1.register_to_service @srv
    assert_equal @srv.registrations[1].node, @node1
    @node2.register_to_service @srv
    assert_equal @srv.registrations[2].node , @node2
  end

  def test_user
    @node1.register_profile(@user1)
    @node1.register_profile(@user2)
    assert_equal @node1.profiles[1].user, @user1
    assert_equal @node1.profiles[2].user , @user2
    assert_equal @node1.profiles[3], NIL
    assert_equal @node1.profiles.size, 2

    @node2.register_profile(@user3)
    p @node1.profiles.size.to_s
    p @node1.profiles[1].class.to_s
    p @node2.profiles[3].class.to_s
    assert_equal @node2.profiles[3].user, @user3

  end

end