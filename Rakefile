# -- Setup
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# -- Defaults
task default: :test

# -- Install tasks
Bundler::GemHelper.install_tasks

# -- Tests
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb'] + FileList['test/*_spec.rb']
  t.verbose = true
end

# -- Linting
desc 'Validate .travis.yml'
task :'travis-lint' do
  sh "travis-lint #{File.expand_path('.travis.yml', __dir__)}"
end
