require 'rubygems'
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do 
  add_filter '/test/'
  add_group 'API',      '/app/api'
  add_group 'Locales',  '/app/locales'
  add_group 'Models',   '/app/models'
end

ENV['RACK_ENV'] ||= 'test'

require 'bundler/setup'
require_relative '../config/application.rb'
Dir[File.expand_path('../helpers/**/*.rb', __FILE__)].reduce(self, :require)

AN.initialize!

require 'pry'
require 'minitest/autorun'

class Minitest::Test
  include AN::Test::API
end
