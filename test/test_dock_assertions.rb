require_relative 'helpers/dock_helper'

class TestDockAssertions < Minitest::Test

  include DockTest::Methods

  def test_assert_response_status_method
    get '/api', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_status 200
  end

  def test_assert_response_content_type_method
    get '/api', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_content_type 'application/json'
  end

  def test_assert_response_headers_method
    get '/api?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_headers({"content-type"=>["application/json"]} , {exclude: ['content-length', 'server', 'connection', 'date', 'via', 'age']})
  end

  def test_assert_response_body_method
    skip unless ENV['DOCK_ENV'] == 'development'
    get '/api?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_body '{"verb":"GET","uri":"#{DockTest.url}/path?foo=bar&a=b","body":"","protocol":"HTTP/1.1","headers":{"ACCEPT":"*/*","USER_AGENT":"Ruby","CONTENT_TYPE":"application/json","HOST":"localhost:9871","VERSION":"HTTP/1.1"}}'
  end

  def test_assert_response_json_schema_method
    get '/api?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_json_schema 'helpers/dock_response.schema.json'
  end

end
