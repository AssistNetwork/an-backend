require 'pry'
require 'swagger'
require 'rack/test'
require 'minitest/autorun'

def swagger_schema
  @schema ||= open(File.expand_path('../schema/swagger-schema.json', __FILE__)).read
end

Minitest.after_run {
  api = Swagger.to_doc
  puts MultiJson.dump(api, pretty: true)
  Swagger.apis.each do |api|
    puts MultiJson.dump(api.to_doc, pretty: true)
  end
  errors = JSON::Validator.fully_validate(swagger_schema, api)
  errors.each do |error|
    puts error
  end
}

class Minitest::Test

  Swagger.init do |api|
    api.api_version = '1.0'
    api.title       = 'My API'
  end

end
