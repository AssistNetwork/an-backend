require_relative 'test_helper'
#TODO Minitest sample!


class RootTest < Minitest::Test

  def test_responds_to_api_with_its_version
    assert_equal get('/api').json['version'],'v1'
  end

  def test_responds_to_api_with_its_environment
    assert_equal get('/api').json['environment'], 'test'
  end

end