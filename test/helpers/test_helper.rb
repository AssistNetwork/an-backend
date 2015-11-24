ENV['RACK_ENV']='test'

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/test/'
  add_group 'API',      '/app/api'
#  add_group 'Locales',  '/app/locales' #TODO i18n
  add_group 'Models',   '/lib/an'  #TODO ez hol legyen? nem a lib-ben a helye?
end

require 'bundler/setup'

require 'grape'
require 'json'
require 'ohm'
require 'ohm/contrib'
require 'ohm/stateful_model'
require 'minitest'
require 'minitest/autorun'

require 'rack/test'
#require 'swagger'

require 'pathname'

require_relative '../../lib/an'
require_relative '../../config/environment'
require_relative '../../app/api/v1'


#def swagger_schema
#  @schema ||= open(File.expand_path('schema/swagger-schema.json', __FILE__)).read
#end

#Minitest.after_run {
#  api = Swagger.to_doc
#  puts MultiJson.dump(api, pretty: true)
#  Swagger.apis.each do |api|
#    puts MultiJson.dump(api.to_doc, pretty: true)
#  end
#  errors = JSON::Validator.fully_validate(swagger_schema, api)
#  errors.each do |error|
#    puts error
#  end
#}

class APITest < Minitest::Test
  include Rack::Test::Methods
#  include Swagger::Test

  def setup
#    Ohm.redis = ENV['REDIS_URL']
#    Ohm.redis ||= Redic.new("redis://127.0.0.1:6379")
#    Ohm.redis.call("FLUSHALL")
    AN.initialize!
#    config
    @path = Pathname(File.expand_path(File.dirname(__FILE__)) + '/../data' )
  end

  def app
    AN::V1
  end

#  def config 

#    @srv = Service.create JSON.parse(File.read( @path +'service.json'))
#    @srv.save

#    @node1 = Node.create JSON.parse(File.read( @path + 'node1.json'))
#    @node1.save
#    @node2 = Node.create JSON.parse(File.read( @path + 'node2.json'))
#    @node2.save

#    @user1 = User.create JSON.parse(File.read( @path + 'user1.json'))
#    @user1.save
#    @user2 = User.create JSON.parse(File.read( @path + 'user2.json'))
#    @user2.save
#    @user3 = User.create JSON.parse(File.read( @path + 'user3.json'))
#    @user3.save
#
#  end

=begin
  swagger.path = '/api'
  swagger.description = 'Assist.Network API v1'

  def test_swagger
    assert_equal Swagger::SWAGGER_VERSION, Swagger.swagger_version
    assert_equal 'My API', Swagger.resource_listing.info.title
  end

  def test_swagger_resource
    refute Swagger.resource_listing.apis.empty?
    assert_equal '/users', self.class.resource.path
    assert_equal 'User resource', self.class.resource.description
  end

  def test_swagger_index
    swagger(:index) do |swagger|
      swagger.summary = 'Summary 1'
      swagger.notes   = 'Notes 1'

      get '/users'
      assert last_response.ok?
    end
  end

  def test_swagger_show
    swagger(:show) do |swagger|
      swagger.summary = 'Summary 2'
      swagger.notes   = 'Notes 2'

      get '/users', user_id: '12345'
      assert last_response.ok?
    end
  end

  def test_swagger_create
    swagger(:create) do |swagger|
      swagger.summary = 'Summary 3'
      swagger.notes   = 'Notes 3'

      post '/users?key=123', user_id: '12345'
      assert last_response.ok?
    end
  end
=end

end

=begin
class Minitest::Test

  Swagger.init do |api|
    api.api_version = '0.1.0'
    api.title       = 'Assist.Network API'
  end

end
=end

# We don't need pry at all costs... :)
begin
  require 'pry'
rescue LoadError
end

