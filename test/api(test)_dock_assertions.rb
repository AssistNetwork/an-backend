require_relative 'helpers/dock_helper'

class Api(test) < Minitest::Test

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
    assert_response_headers({"content-type"=>["application/json"]} , {exclude: ['vary', 'content-length', 'server', 'connection', 'date', 'via', 'age']})
  end

  def test_assert_response_body_method
    skip unless ENV['DOCK_ENV'] == 'development'
    get '/api?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_body '{"verb":"GET","uri":"#{DockTest.uri}/path?foo=bar&a=b","body":"","protocol":"HTTP/1.1","headers":{"ACCEPT":"*/*","USER_AGENT":"Ruby","CONTENT_TYPE":"application/json","HOST":"#{DockTest.uri}","VERSION":"HTTP/1.1"}}'
  end

  def test_assert_response_json_schema_method
=begin
if env['HTTP_CONTENT_TYPE'] == 'application/json'
    request_json = {
      verb: env["REQUEST_METHOD"],
      uri:  env["REQUEST_URI"],
      body: env["rack.input"].read,
      protcol: env["SERVER_PROTOCOL"],
      headers: Hash[env.select {|k, v| k.start_with?("HTTP_") }.map {|k, v| [k[5..-1], v] }]
    }.to_json

    [200, {'Content-Type' => "application/json", 'Content-Length' => request_json.length.to_s}, [request_json]]
  else
    [200, {'Content-Type' => "application/xml"}, ['<foo><bar>baz</bar></foo>']]
  end
=end

    get '/api?foo=bar', {a: :b}, {'CONTENT_TYPE' => 'application/json'}
    assert_response_json_schema 'helpers/dock_response.schema1.json'
  end

end
