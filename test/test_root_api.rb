require_relative 'test_helper'
#TODO Minitest sample!


class RootTest < Minitest::Test

  def responds_to_api_with_its_version
    assert_equal get('/api').json['version'],'v1'
  end

  def responds_to_api_with_its_environment
    assert_equal get('/api').json['environment'], 'test'
  end

end