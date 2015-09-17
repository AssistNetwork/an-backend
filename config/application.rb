# Setup sane defaults
ENV['RACK_ENV'] ||= 'development'

require 'bundler/setup'
require_relative '../lib/an.rb'
Dir[File.expand_path('initializers/**/*.rb', __dir__)].reduce(self, :require)
Dir[File.expand_path('../app/api/v1/**/*.rb', __dir__)].reduce(self, :require)
require_relative '../app/api/v1.rb'
