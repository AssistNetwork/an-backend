AN.configure do |an|
  an.redis   = ENV['REDIS']
  an.redis ||= 'redis://localhost:9372' if AN.development? or AN.test?
  AN.logger.error "There is no :redis_config provided!  Please specify one in ENV['REDIS']." unless an.redis
end