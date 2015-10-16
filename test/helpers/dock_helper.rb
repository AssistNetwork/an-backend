require 'bundler/setup'
require 'minitest/autorun'
Bundler.require(:default, :test)

require_relative 'dock_test'

DockTest.configure do |c|
  case ENV['DOCK_ENV']
  when 'production'
    c.url = 'http://assist-network.herokuapp.com'
    c.skippy = true
  else
    c.url = 'http://localhost:9292'
    c.skippy = false
  end
end

