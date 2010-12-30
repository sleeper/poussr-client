require 'poussr_client/request'

module PoussrClient

  class Channel

    attr_reader :url, :name
    
    def initialize(url, name)
      @url = url
      @name = name
    end
    
    def trigger(event, data)
      require 'net/http' unless defined?(Net::HTTP)

      @http_sync ||= begin
                       http = Net::HTTP.new(@url.host, @url.port)
                       http
                     end

      request = Request.new(event, data)
      path = @url.path + "/channels/#{@name}/events?#{request.query}"
      
      response = @http_sync.post("#{path}",
                                 request.body, { 'Content-Type'=> 'application/json' })

      case response.code.to_i
      when 202
        return true
      else
        PoussrClient.logger.error("Bad request: #{request.body} -> #{response.code}")
        return false
      end
    end
    
  end
  
end
