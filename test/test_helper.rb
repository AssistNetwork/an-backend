unless ENV['RACK_ENV']='development'

  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
  add_filter '/test/'
  add_group 'API',      '/app/api'
  add_group 'Locales',  '/app/locales' #TODO ez hol legyen? nem a lib-ben a helye?
  add_group 'Models',   '/app/models'  #TODO ez hol legyen? nem a lib-ben a helye?
end

end

ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require_relative '../config/application.rb'
Dir[File.expand_path('helpers/**/*.rb', __FILE__)].reduce(self, :require)

AN.initialize!

require 'minitest/autorun'

class Minitest::Test
  include AN::Test::API
end

# We don't need pry at all costs... :)
begin
  require 'pry'
rescue LoadError
end
