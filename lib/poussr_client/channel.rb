require 'poussr_client/request'

module PoussrClient

  class Channel

    def trigger(event, data)
      require 'net/http' unless defined?(Net::HTTP)

      host = "someserver.com"
      port = 12345
      body = data
      @http_sync ||= begin
                       http = Net::HTTP.new(host, port)
                       http
                     end

      request = Request.new(event, data)
      path = "/base/channels/mychannel/events?#{request.query}"
      
      response = @http_sync.post("#{path}",
                                 request.body, { 'Content-Type'=> 'application/json' })
    end
    
  end
  
end
