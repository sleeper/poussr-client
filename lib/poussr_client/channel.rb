require 'poussr_client/request'

module PoussrClient

  class Channel

    attr_reader :url, :name
    
    def initialize(url, name)
      @url = url.dup
      @url.path = @url.path + "/channels/#{name}/events"
      @name = name
    end

    def trigger_async(event,data)
      unless defined?(EventMachine) && EventMachine.reactor_running?
        raise Error, "In order to use trigger_async you must be running inside an eventmachine loop"
      end
      require 'em-http' unless defined?(EventMachine::HttpRequest)
      
      @http_async ||= EventMachine::HttpRequest.new(@url)

      request = PoussrClient::Request.new(event, data)

      deferrable = EM::DefaultDeferrable.new
      
      http = @http_async.post({
        :query => request.query, :timeout => 2, :body => request.body,
        :head => {'Content-Type'=> 'application/json'}
      })
      http.callback {
        begin
#          handle_response(http.response_header.status, http.response.chomp)
          deferrable.succeed
        rescue => e
          deferrable.fail(e)
        end
      }
      http.errback {
        PoussrClient.logger.debug("Network error connecting to Poussr: #{http.inspect}")
        deferrable.fail(Error.new("Network error connecting to Poussr"))
      }
      
      deferrable
    end

    
    def trigger(event, data)
      require 'net/http' unless defined?(Net::HTTP)

      @http_sync ||= begin
                       http = Net::HTTP.new(@url.host, @url.port)
                       http
                     end

      request = Request.new(event, data)
      
      response = @http_sync.post("#{@url.path}?#{request.query}",
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
