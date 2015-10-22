# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ohm-zset/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Josh']
  gem.email         = ['akosijoshualat@gmail.com']
  gem.description   = %q{Adds ZSet support to Ohm}
  gem.summary       = %q{Adds ZSet support to Ohm}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'ohm-zset'
  gem.require_paths = ['lib']
  gem.version       = Ohm::Zset::VERSION

  gem.add_dependency 'redis'
  gem.add_dependency 'ohm'
  gem.add_dependency 'ohm-contrib'
  gem.add_dependency 'uuidtools'
  gem.add_dependency 'sourcify'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'minitest'
end
