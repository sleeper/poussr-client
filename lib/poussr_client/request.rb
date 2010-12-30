require 'json'

module PoussrClient

  class Request
    attr_reader :query, :body

    def initialize(event_name, data)
      @query = "name=#{event_name}"
      @body = case data
              when String
                data
              else
                begin
                  JSON.generate(data)
                rescue => e
                  PoussrClient.logger.error("Could not convert #{data.inspect} into JSON")
                end
              end
    end
  end
end
