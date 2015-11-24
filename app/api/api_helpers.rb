require 'redis'
require 'logger'
require 'grape'

LIMIT = 20

module ApiHelpers

  def authenticate!
    error!('401 Unauthorized', 401) unless headers['Auth'] == 'an-dev'
  end

  def cmd_type (cmd)
    case cmd.to_s
      when 'd'
        'Demand'
      when 's'
        'Supply'
      when 'o'
        'Offer'
      when 'e'
        'Event'
      when 'i'
        'Info'
      when 'c'
        'Carrier'
      else
        ''
    end
  end

  def paginate(set, page_num, limit)

    if limit.nil?
      limit = LIMIT
    end

    if page_num.nil?
      page_num = 1
    end

    # Get number of pages
    num_pages = 1 + set.size / limit
    start = (page_num - 1) * limit

    # Select range
    if set.respond_to? :range
      # It's a zset
      limited_set = set.revrange(start, start + limit)
    else
      # Normal set
      limited_set = set.sort(limit: [start, limit], order: 'DESC')
    end

    # Generate response
    {:num_pages => num_pages, :page => limited_set.to_a.map{|e| e.to_hash}}
  end

  def rescue_db_errors
    begin
      yield
    rescue Redis::BaseError => e
      Logger.new(STDERR).error("Redis Error Rescued. Error message: #{e}.")
      {:success => false}
    end
  end
end

# avoid superclass mismatch when version file gets loaded first
Grape::Middleware.send :remove_const, :Logger if defined? Grape::Middleware::Logger
module Grape
  module Middleware
    class Logger < Grape::Middleware::Globals

      def before
        start_time
        super # sets env['grape.*']
        logger.info ''
        logger.info %Q(Started #{env['grape.request'].request_method} "#{env['grape.request'].path}")
        logger.info %Q(  Parameters: #{parameters})
      end

      # @note Error and exception handling are required for the +after+ hooks
      #   Exceptions are logged as a 500 status and re-raised
      #   Other "errors" are caught, logged and re-thrown
      def call!(env)
        @env = env
        before
        error = catch(:error) do
          begin
            @app_response = @app.call(@env)
            @app_response = @app_response.to_a if @app_response.is_a?(Rack::Response)
          rescue => e
            after_exception(e)
            raise e
          end
          nil
        end
        if error
          after_failure(error)
          throw(:error, error)
        else
#          after(@app_response.status)
          after(@app_response[0])
        end
        @app_response
      end

      def after(status)
        logger.info "Completed #{status} in #{((Time.now - start_time) * 1000).round(2)}ms"
        logger.info ''
      end

      #
      # Helpers
      #

      def after_exception(e)
        logger.info %Q(  Error: #{e.message})
        after(500)
      end

      def after_failure(error)
        logger.info %Q(  Error: #{error[:message]}) if error[:message]
        after(error[:status])
      end

      def parameters
        request_params = env['grape.request.params'].to_hash
#        request_params.merge!(env['action_dispatch.request.request_parameters'] || {}) # for Rails
        if @options[:filter]
          @options[:filter].filter(request_params)
        else
          request_params
        end
      end

      def start_time
        @start_time ||= Time.now
      end

      def logger
        @logger ||= @options[:logger] || ::Logger.new(STDOUT)
      end
    end
  end
end