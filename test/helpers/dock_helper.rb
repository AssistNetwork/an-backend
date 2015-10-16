require 'bundler/setup'
require 'minitest/autorun'
Bundler.require(:default, :test)

require_relative 'dock_test'

DockTest.configure do |c|
  case ENV['DOCK_ENV']
  when 'production'
    c.uri = 'http://assist-network.herokuapp.com'
    c.skippy = true
  else
    c.uri = 'http://localhost:9292'
    c.skippy = false
  end
end

