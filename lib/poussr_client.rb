require 'logger'
require 'uri'

module PoussrClient

  class << self
    attr_accessor :host, :port, :base
    attr_writer :logger

    def logger
      @logger ||= begin
                     log = Logger.new STDOUT
                     log.level = Logger::INFO
                     log
                   end
    end

    def url=(url)
      uri = URI.parse(url)
      self.host = uri.host
      self.port = uri.port
      self.base = uri.path
    end

    def [](channel)
      @channels ||= {}
      @channels[channel] ||= Channel.new
    end
    
  end
  
end

require 'poussr_client/channel'
