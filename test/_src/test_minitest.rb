require 'minitest/autorun'

class Valami
  def title
    'valami'
  end
end

class TestMinitest < Minitest::Test

  def setup
    @valami = Valami.new
  end

  def test_valami
    assert_equal 'valami', @valami.title
  end
end
