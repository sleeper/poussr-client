require 'logger'
require 'uri'

module PoussrClient

  class << self
    attr_accessor :host, :port, :base
    attr_writer :logger
    attr_reader :url
    
    def logger
      @logger ||= begin
                     log = Logger.new STDOUT
                     log.level = Logger::INFO
                     log
                   end
    end

    def url=(url)
      @url = URI.parse(url)
      self.host = @url.host
      self.port = @url.port
      self.base = @url.path
    end

    def [](channel)
      @channels ||= {}
      @channels[channel] ||= Channel.new(@url, channel)
    end
    
  end
  
end

require 'poussr_client/request'
require 'poussr_client/channel'
