#\ -s puma

require 'rack/cors'
require_relative 'config/environment'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete]
  end
end

run AN.app