module DockTest
  module DSL

    attr_reader :uri
    # sets the test uri
    def uri=(value)
      @uri = value
    end

    # oauth settings
    attr_accessor :oauth_consumer_key, :oauth_consumer_secret

    # if the current dock_test environment requires oauth
    def oauth?
      oauth_consumer_key && oauth_consumer_secret
    end

    def mount_path
      p = URI.parse(@url).path
      p.empty? ? '/' : p
    end

    def port
      URI.parse(@url).port
    end

    def localhost?
      @url && ['127.0.0.1', 'localhost'].include?(URI.parse(@url).host)
    end

    def skippy=(skippy)
      @skippy = skippy
    end

    def skippy?
      @skippy || false
    end

    def verify_ssl=(verify_ssl)
      @verify_ssl = verify_ssl
    end

    def verify_mode
      if @verify_ssl.nil? || @verify_ssl
        OpenSSL::SSL::VERIFY_PEER
      else
        OpenSSL::SSL::VERIFY_NONE
      end
    end

    def configure(&block)
      block.call(DockTest)
    end
  end
end
