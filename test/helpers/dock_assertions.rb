module Minitest::Assertions
  def assert_response_status(status)
    assert last_response.code == status.to_s, "The actual response status is #{last_response.code}"
  end

  def assert_response_content_type(content_type)
    assert last_response['Content-Type'] == content_type.to_s, "The actual response content_type is #{last_response['Content-Type']}"
  end

  def assert_response_headers(headers, options = {})
    exclude_keys = Array(options[:exclude] || [])
    response_headers = last_response.to_hash.delete_if {|k, _| exclude_keys.include?(k)}
    assert response_headers == headers, "The actual response headers are #{response_headers.inspect}"
  end

  def assert_response_body(body_string)
    assert last_response.body == body_string, "The actual response body is #{last_response.body}"
  end

  def assert_response_json_schema(schema_path)
    schema = File.open(schema_path).read
    errors = JSON::Validator.fully_validate(schema, last_response.body)
    assert errors.empty?, "The actual response does not match the schema defined in #{schema_path} because #{errors.join(', ')}"
  end

end
