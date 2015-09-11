#$:.push File.expand_path("../lib", __FILE__)

require_relative "config/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.authors     = ['Bence Golda']
  gem.email       = ['gbence@gmail.com']
  gem.description = 'Assist Network Backend Service'
  gem.summary     = 'Backend Service and API for Assist Network.'

  gem.name        = 'an-backend'
  gem.version     = AN::VERSION

  # Dependencies
  gem.add_dependency 'grape'
  gem.add_dependency 'rack-cors'

  # Build and task management
  gem.add_development_dependency 'rake'

  # Specification and documentation
  #gem.add_development_dependency 'yard'
  
  # Tests and coverage
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'coveralls'

  # Tools
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'travis-lint'

  # Files
  gem.files = `git ls-files`.split
  gem.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  #gem.require_paths = ['lib']
end

