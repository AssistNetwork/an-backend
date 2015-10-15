# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|

  gem.authors     = ['Bence Golda', 'Gabor Nagymajtenyi']
  gem.email       = ['gbence@gmail.com', 'gabor.nagymajtenyi@gmail.com']
  gem.description = 'Assist Network Backend Service'
  gem.summary     = 'Backend Service and API for Assist Network.'
  gem.homepage    = 'https://github.com/AssistNetwork'

  gem.name        = 'an-backend'
  gem.version     = '0.1.0'
  gem.require_paths = ['lib']

  # Ruby
  gem.required_ruby_version = '>= 2.2.0'
  gem.required_rubygems_version = '>= 2.2.0'

  # Dependencies

  gem.add_dependency 'rake'
  gem.add_dependency 'puma'
  gem.add_dependency 'grape'
  gem.add_dependency 'rack-cors'
  gem.add_dependency 'ohm'
  gem.add_dependency 'ohm-stateful-model'
  gem.add_dependency 'ohm-zset'
  gem.add_dependency 'ohm-contrib'
  gem.add_dependency 'minitest'
  gem.add_dependency 'rack-test'
  gem.add_dependency 'travis'
  gem.add_dependency 'travis-lint'
  gem.add_dependency 'simplecov'
  gem.add_dependency 'coveralls'
  gem.add_dependency 'pry'
  gem.add_dependency 'rubocop'

  # Specification and documentation
  #gem.add_development_dependency 'yard'

  #gem.add_development_dependency 'minitest-reporters'

  
  # Files
  unless ENV['DYNO'] # check whether we're running on Heroku or not
    gem.files = `git ls-files`.split
    gem.test_files = Dir['test/**/*']
    gem.executables = Dir['bin/*'].map { |f| File.basename(f) }
  end
end
