require_relative 'application'

Dir[File.expand_path('initializers/**/*.rb', __dir__)].reduce(self, :require)

AN.initialize!
