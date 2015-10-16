require 'multi_json'
require 'json-schema'
require_relative 'dock_version'
require_relative 'dock_methods'
require_relative 'dock_dsl'

if defined?(::Minitest)
  require_relative 'dock_assertions'
else
end

module DockTest
  extend DSL
end
