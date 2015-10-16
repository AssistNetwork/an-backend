require_relative 'helpers/dock_helper'

class Api(test) < Minitest::Test

  include DockTest::Methods

  def test_get_method_with_hash_body
    get '/api?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/api?foo=bar&a=b"
    assert_equal last_response_json['verb'], 'GET'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_get_method_with_string_body
    get '/api?foo=bar', 'a=b', {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/api?foo=bar&a=b"
    assert_equal last_response_json['verb'], 'GET'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_get_method_to_root
    get '/api', 'a=b', {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/?a=b"
    assert_equal last_response_json['verb'], 'GET'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_post_method
    post '/api?foo=bar', MultiJson.dump({guid: '12345'}), {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/api?foo=bar"
    assert_equal last_response_json['verb'], 'POST'
    assert_equal last_response_json['body'], "{\"guid\":\"12345\"}"
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_put_method
    put '/api?foo=bar', MultiJson.dump({guid: '12345'}), {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/api?foo=bar"
    assert_equal last_response_json['verb'], 'PUT'
    assert_equal last_response_json['body'], "{\"guid\":\"12345\"}"
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_patch_method
    patch '/api?foo=bar', MultiJson.dump({guid: '12345'}), {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/api?foo=bar"
    assert_equal last_response_json['verb'], 'PATCH'
    assert_equal last_response_json['body'], "{\"guid\":\"12345\"}"
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_delete_method
    delete '/api?foo=bar', '', {'CONTENT_TYPE' => 'application/json'}

    assert_equal last_response_json['uri'], "#{DockTest.uri}/api?foo=bar"
    assert_equal last_response_json['verb'], 'DELETE'
    assert_equal last_response_json['body'], ''
    assert_equal last_response_json['headers']['CONTENT_TYPE'], 'application/json'
  end

  def test_accept_header_nil
    get '/api', '', {'Accept' => nil, 'CONTENT_TYPE' => 'application/json'}
    assert_equal last_response_json['headers']['ACCEPT'], nil
  end

  private
    def last_response_json
      MultiJson.load(last_response.body)
    end
end

