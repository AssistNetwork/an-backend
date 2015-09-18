#$:.push File.expand_path("../lib", __FILE__)

require_relative "config/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.authors     = ['Bence Golda']
  gem.email       = ['gbence@gmail.com']
  gem.description = 'Assist Network Backend Service'
  gem.summary     = 'Backend Service and API for Assist Network.'
  gem.homepage    = 'https://github.com/AssistNetwork'

  gem.name        = 'an-backend'
  gem.version     = AN::VERSION
  #gem.require_paths = ['lib']

  # Ruby
  gem.required_ruby_version = '>= 2.1.0'
  gem.required_rubygems_version = '>= 2.1.0'

  # Dependencies
  gem.add_dependency 'rake'
  gem.add_dependency 'puma'
  gem.add_dependency 'grape'
  gem.add_dependency 'rack-cors'

  # Specification and documentation
  #gem.add_development_dependency 'yard'
  
  # Files
  unless ENV['DYNO'] # check whether we're running on Heroku or not
    gem.files = `git ls-files`.split
    gem.test_files = Dir['test/**/*']
    gem.executables = Dir['bin/*'].map { |f| File.basename(f) }
  end
end
