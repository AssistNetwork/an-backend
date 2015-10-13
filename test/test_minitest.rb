require 'minitest/autorun'
#require 'minitest/reporters'

#Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class TestMinitest < Minitest::Test

#  def setup
    #Ohm.redis.flushall
#    p 'minitest-setup'
#  end

  def valami
    assert_equal 'valami', 'valami'
  end


end
