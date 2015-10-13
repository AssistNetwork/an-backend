require 'redis'

module ApiHelpers

  def authenticate!
    error!('401 Unauthorized', 401) unless headers['Auth'] == 'an-dev'
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