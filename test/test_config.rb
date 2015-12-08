Dir[File.expand_path('helpers/**/*.rb', __dir__)].reduce(self, :require)


class TestConfig < APITest

  def setup
    @node1 = Node[1]
    @node2 = Node[2]
    @srv = Service[1]
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
    @path = Pathname(File.expand_path(File.dirname(__FILE__)) + '/data' )
    @user4 = User.create JSON.parse(File.read(@path + 'user4.json'))
    @user5 = User.create JSON.parse(File.read(@path + 'user5.json'))
    @user6 = User.create JSON.parse(File.read(@path + 'user6.json'))
    @user4.save
    @user5.save
    @user6.save
    @node1.register_profile(@user4)
    @node1.register_profile(@user5)
    assert_equal @node1.profiles[4].user, @user4
    assert_equal @node1.profiles[5].user , @user5
    assert_equal @node1.profiles[6], NIL
    assert_equal @node1.profiles.size, 4

    @node2.register_profile(@user6)
    p @node1.profiles.size.to_s
    p @node1.profiles[4].class.to_s
    p @node2.profiles[5].class.to_s
    assert_equal @node2.profiles[6].user, @user6

  end

end