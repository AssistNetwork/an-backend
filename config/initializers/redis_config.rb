AN.configure do |an|
  an.redis   = ENV['REDISCLOUD_URL']
  an.redis ||= 'redis://localhost:6379' if AN.development? or AN.test?
#  AN.logger.error "There is no :redis_config provided!  Please specify one in ENV['REDIS']." unless an.redis
end