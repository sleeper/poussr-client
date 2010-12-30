require 'poussr_client/request'

module PoussrClient

  class Channel

    attr_reader :url
    
    def initialize(url)
      @url = url
    end
    
    def trigger(event, data)
      require 'net/http' unless defined?(Net::HTTP)

      @http_sync ||= begin
                       http = Net::HTTP.new(@url.host, @url.port)
                       http
                     end

      request = Request.new(event, data)
      path = @url.path + "/channels/mychannel/events?#{request.query}"
      
      response = @http_sync.post("#{path}",
                                 request.body, { 'Content-Type'=> 'application/json' })
    end
    
  end
  
end
